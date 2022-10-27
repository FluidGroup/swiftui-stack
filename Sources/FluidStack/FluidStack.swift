import FluidInterfaceKit
@_exported import Stack
import Stack
import SwiftUI

@_spi(StackContext) import Stack

/// backed by ``FluidInterfaceKit/FluidStackController``
public typealias FluidStack<Data, Root: View> = AbstractStack<Data, Root, FluidStackDisplaying<Root>>

/// The implementation of ``AbstractStack``
public struct FluidStackDisplaying<Root: View>: UIViewControllerRepresentable, StackDisplaying {
  
  @Environment(\.stackContext) var stackContext: _StackContext?

  public typealias UIViewControllerType = FluidStackController

  private let root: Root
  private let stackedViews: [StackedView]

  public init(
    root: Root,
    stackedViews: [StackedView]
  ) {
    self.root = root
    self.stackedViews = stackedViews
  }

  private func makeController(view: StackedView) -> FluidViewController {
      
    let body = _FluidStackHostingController(stackedView: view)

    let controller = FluidViewController(
      content: .init(
        bodyViewController: body
      ),
      configuration: .init(
        transition: .empty,
        topBar: .navigation(.default)
      )
    )
    
    controller.addFluidStackActionHandler { action in
      switch action {
      case .willPush:
        break
      case .willPop:
        break
      }
    }
    
    controller.removingInteraction = .leftToRightOnScreen
    
    // FIXME: handle poped by gesture.

    body.navigationItem.leftBarButtonItem = .fluidChevronBackward(onTap: { @MainActor [id = view.id] in
      guard let stackContext else {
        assertionFailure()
        return
      }
      
      stackContext.pop(identifier: id)
    })

    return controller
  }

  public func makeUIViewController(context: Context) -> FluidInterfaceKit.FluidStackController {
    
    assert(stackContext != nil)
    
    // FIXME: identifiers

    let controller = FluidStackController(
      identifier: .init("TODO"),
      view: nil,
      contentView: nil,
      configuration: .init(
        retainsRootViewController: true,
        isOffloadViewsEnabled: true,
        preventsFowardingPop: false
      ),
      rootViewController: FluidViewController.init(
        content: .init(bodyViewController: UIHostingController(rootView: root)),
        configuration: .init(transition: .empty, topBar: .navigation(.default))
      )
    )

    return controller
  }

  public func updateUIViewController(
    _ uiViewController: FluidInterfaceKit.FluidStackController,
    context: Context
  ) {
    
    assert(stackContext != nil)
    
    let currentViewControllers: [UIViewController] = Array(
      uiViewController
        .stackingViewControllers
        .dropFirst()
    )

    let currentItems: [StackedView] = currentViewControllers
      .map {
        let hosting =
        ($0 as! FluidViewController).content.bodyViewController as! _FluidStackHostingController
        return hosting.stackedView
      }
    
    let proposedItems = stackedViews
    
    let difference = proposedItems.difference(from: currentItems)

    Log.debug(.default, difference)

    for change in (difference.removals + difference.insertions) {
      switch change {
      case let .remove(offset, element, associatedWith):
        
        currentViewControllers[offset].fluidPop(transition: .disabled)
                
      case let .insert(offset, element, associatedWith):
        
        uiViewController.fluidPush(
          makeController(view: element),
          target: .current,
          relation: .hierarchicalNavigation,
          transition: .jump,
          completion: { event in
            
          }
        )

      }
    }
  }

}

final class _FluidStackHostingController: UIHostingController<EquatableView<StackedView>> {
  
  let stackedView: StackedView

  init(stackedView: StackedView) {
    self.stackedView = stackedView
    super.init(rootView: EquatableView(content: stackedView))
  }

  @MainActor required dynamic init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

extension CollectionDifference {

  fileprivate func transform<U>(_ transform: (ChangeElement) -> U) -> CollectionDifference<U> {

    let mapped = map { change -> CollectionDifference<U>.Change in
      switch change {
      case .insert(let offset, let element, let associatedWith):
        return .insert(offset: offset, element: transform(element), associatedWith: associatedWith)
      case .remove(let offset, let element, let associatedWith):
        return .remove(offset: offset, element: transform(element), associatedWith: associatedWith)
      }
    }

    return .init(mapped)!

  }

}
