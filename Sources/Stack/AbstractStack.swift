import SwiftUI
/**
 - TODO:
 - [x] Path
 - [x] momentary presentation
 - [ ] Nesting support

 memo:
 https://www.avanderlee.com/swiftui/navigationlink-programmatically-binding/
 */
@MainActor
public struct AbstractStack<Data, Root: View, Target: StackDisplaying>: View where Target.Root == Root {

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

    EnvironmentReader(keyPath: \.stackContext) { parentContext in

      Target(
        root: root,
        stackedViews: context.stackedViews
      )
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      // propagates context to descendants
      .environment(\.stackContext, context)
      .environment(\.stackNamespaceID, namespace)
      .environmentObject(context)
      .onReceive(context.$path, perform: { path in
        Log.debug(.stack, "Receive \(path)")

        pathBinding?.wrappedValue = path
        self.currentPath = path
      })
      .onChangeWithPrevious(of: pathBinding?.wrappedValue, emitsInitial: true, perform: { path, _ in

        /*
         Updates current stacking with path changes.
         */
        guard let path, path != self.currentPath else { return }

        context.receivePathUpdates(path: path)
      })
      .onChangeWithPrevious(of: parentContext, emitsInitial: true) { parent, _ in
        context.set(parent: parent)
      }

    }

  }

}
