import SwiftUI

public protocol StackDisplaying: View {
  
  associatedtype Root: View
  
  init(
    root: Root,
    stackedViews: [StackedView]
  )
}
