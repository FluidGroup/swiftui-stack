import SwiftUI

/// A view that receives a root view and views for displaying.
/// It's an abstract view that uses a concrete view to display.
/// You may use ``Stack`` for basic stacking.
///
/// - TODO:
/// - [x] Path
/// - [x] momentary presentation
/// - [ ] Nesting support
///
/// memo:
/// https://www.avanderlee.com/swiftui/navigationlink-programmatically-binding/
@MainActor
public struct AbstractStack<Data, Root: View, Target: StackDisplaying>: View
where Target.Root == ModifiedContent<Root, AbstractStackRootModifier> {

  @StateObject private var context: _StackContext

  private let root: Root

  private let pathBinding: Binding<StackPath>?

  @State private var currentPath: StackPath?

  @Namespace var namespace

  public init(
    identifier: StackIdentifier? = nil,
    @ViewBuilder root: () -> Root
  ) where Data == StackPath {

    // TODO: I don't know how to create Binding without data source(State)
    // Instead, context uses two way handlings case of Bindings presents or not.
    self.pathBinding = nil
    self.root = root()
    self._context = .init(wrappedValue: .init(identifier: identifier))
  }

  public init(
    identifier: StackIdentifier? = nil,
    path: Binding<StackPath>,
    @ViewBuilder root: () -> Root
  ) where Data == StackPath {

    self.pathBinding = path
    self.root = root()
    self._context = .init(wrappedValue: .init(identifier: identifier))
  }

  public var body: some View {

    // For retrieving if the parent context is there.
    EnvironmentReader(keyPath: \.stackContext) { parentContext in

      GeometryReader { proxy in
        Target(
          root: root.modifier(AbstractStackRootModifier(namespace: namespace)),
          stackedViews: context.stackedViews
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .environment(\._safeAreaInsets, proxy.safeAreaInsets)
        // propagates context to descendants
        .environment(\.stackContext, context)
        .environment(\.stackNamespaceID, namespace)
        // workaround
        .environmentObject(context)
        .onReceive(
          context.$path,
          perform: { path in
            Log.debug(.stack, "Updated Path : \(path)")

            pathBinding?.wrappedValue = path
            self.currentPath = path
          }
        )
        .onChange(of: pathBinding?.wrappedValue, initial: true, { oldValue, path in
          /*
           Updates current stacking with path changes.
           */
          guard let path, path != self.currentPath else { return }
          
          context.receivePathUpdates(path: path)
        })
        .onChange(of: parentContext, initial: true, { _, parent in
          context.set(parent: parent)
        })
       
      }

    }

  }

}

public struct AbstractStackRootModifier: ViewModifier {

  let namespace: Namespace.ID

  public func body(content: Content) -> some View {
    ZStack {
      content
        // as ignoring safe-area above, retores the safe-area
        .modifier(RestoreSafeAreaModifier())
    }
    // bit tricky - for animations to run as fullscreen.
    .ignoresSafeArea()
    // built-in matched geometry effect, some transitions may use.
    .matchedGeometryEffect(
      id: MatchedGeometryEffectIdentifiers.EdgeTrailing(content: .root),
      in: namespace,
      anchor: .trailing,
      isSource: false
    )

  }
}

private enum SafeAreaInsetsKey: EnvironmentKey {
  static var defaultValue: SwiftUI.EdgeInsets {
    .init()
  }
}

extension EnvironmentValues {
  var _safeAreaInsets: EdgeInsets {
    get { self[SafeAreaInsetsKey.self] }
    set { self[SafeAreaInsetsKey.self] = newValue }
  }
}

struct RestoreSafeAreaModifier: ViewModifier {

  @Environment(\._safeAreaInsets) var safeAreaInsets

  func body(content: Content) -> some View {
    content._safeAreaInsets(safeAreaInsets)
  }

}
