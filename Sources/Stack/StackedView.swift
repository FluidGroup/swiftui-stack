import SwiftUI

/// A wrapper view that displays content with identifier which uses on Pop operation.
public struct StackedView: View, Identifiable, Equatable {

  /// a material of how this view is stacked.
  public enum Material {
    /// For dynamic destination according to the value.
    case value(StackPath.ItemBox)
    /// For dynamic destination according to the binding
    case moment(Binding<Bool>)
    /// For static destination - Link has a destination in the declaration
    case volatile
  }

  public static func == (lhs: StackedView, rhs: StackedView) -> Bool {
    lhs.id == rhs.id
  }

  public let id: _StackedViewIdentifier

  private let content: AnyView

  public let material: Material
  public let linkEnvironmentValues: LinkEnvironmentValues

  init(
    material: Material,
    identifier: _StackedViewIdentifier,
    linkEnvironmentValues: LinkEnvironmentValues,
    content: some View
  ) {
    self.material = material
    self.id = identifier
    self.linkEnvironmentValues = linkEnvironmentValues
    self.content = .init(content)
  }

  public var body: some View {
    content
      .environment(\.stackIdentifier, id)
      .onAppear {

      }
      .onDisappear {

      }
  }

}
