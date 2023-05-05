
enum MatchedGeometryEffectIdentifiers {

  struct EdgeTrailing: Hashable {

    public enum Content: Hashable {
      case root
      case stacked(_StackedViewIdentifier)
    }

    let content: Content

  }

}
