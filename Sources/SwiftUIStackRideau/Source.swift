import Rideau
import SwiftUI
import SwiftUIStack
import SwiftUISupport
import UIKit

public struct RideauStackTransition: StackTransition {

  public func labelModifier() -> some ViewModifier {
    _LabelModifier()
  }

  public func destinationModifier(context: SwiftUIStack.DestinationContext) -> some ViewModifier {
    _DestinationModifier()
  }

  private struct _LabelModifier: ViewModifier {

    func body(content: Content) -> some View {
      content
    }
  }

  private struct _DestinationModifier: ViewModifier {

    @Environment(\.stackUnwindContext) var unwindContext

    func body(content: Content) -> some View {
      SwiftUIRideau(
        configuration: .init(snapPoints: [.hidden, .fraction(1)]),
        initialSnapPoint: .fraction(1),
        onDidDismiss: {
          unwindContext?.pop()
        }
      ) {
        content
      }
    }
  }

}

extension StackTransition where Self == RideauStackTransition {

  public static func rideau() -> Self {
    RideauStackTransition()
  }

}

@available(iOS 14, *)
private struct SwiftUIRideau<Content: View>: UIViewControllerRepresentable {

  final class Coordinator {
    let hostingController: UIHostingController<Content>

    init(hostingController: UIHostingController<Content>) {
      self.hostingController = hostingController
    }
  }

  let content: Content
  let onDidDismiss: @MainActor () -> Void
  let configuration: RideauView.Configuration
  let initialSnapPoint: RideauSnapPoint

  init(
    configuration: RideauView.Configuration,
    initialSnapPoint: RideauSnapPoint,
    onDidDismiss: @escaping @MainActor () -> Void,
    @ViewBuilder conetnt: () -> Content
  ) {
    self.configuration = configuration
    self.initialSnapPoint = initialSnapPoint
    self.content = conetnt()
    self.onDidDismiss = onDidDismiss
  }

  func makeCoordinator() -> Coordinator {

    let hostingController: UIHostingController<Content> = .init(rootView: content)
    hostingController._disableSafeArea = false
    hostingController.view.backgroundColor = .clear

    return .init(hostingController: hostingController)
  }

  func makeUIViewController(context: Context) -> RideauHostingController {

    let controller = RideauHostingController(
      bodyViewController: context.coordinator.hostingController,
      configuration: configuration,
      resizingOption: .noResize,
      usesDismissalPanGestureOnBackdropView: false,
      hidesByBackgroundTouch: true,
      onViewDidAppear: { viewController in
        viewController.rideauView.move(to: initialSnapPoint, animated: true, completion: {})
      }
    )

    controller.onDidDismiss = onDidDismiss

    return controller

  }

  func updateUIViewController(
    _ uiViewController: RideauHostingController,
    context: Context
  ) {

    context.coordinator.hostingController.rootView = content

  }

}

private final class RideauHostingController: UIViewController {

  // MARK: - Properties

  var onWillDismiss: () -> Void = {}
  var onDidDismiss: () -> Void = {}

  let rideauView: RideauView

  let backgroundView: UIView = .init()

  let backgroundColor: UIColor

  private let bodyViewController: UIViewController
  private let resizingOption: RideauContentContainerView.ResizingOption
  private let hidesByBackgroundTouch: Bool
  private let onViewDidAppear: @MainActor (RideauHostingController) -> Void

  // MARK: - Initializers

  init(
    bodyViewController: UIViewController,
    configuration: RideauView.Configuration,
    resizingOption: RideauContentContainerView.ResizingOption,
    backdropColor: UIColor = UIColor(white: 0, alpha: 0.2),
    usesDismissalPanGestureOnBackdropView: Bool = true,
    hidesByBackgroundTouch: Bool = true,
    onViewDidAppear: @escaping @MainActor (RideauHostingController) -> Void
  ) {

    self.hidesByBackgroundTouch = hidesByBackgroundTouch
    self.bodyViewController = bodyViewController
    self.resizingOption = resizingOption
    self.onViewDidAppear = onViewDidAppear

    var c = configuration

    c.snapPoints.insert(.hidden)

    self.rideauView = .init(frame: .zero, configuration: c)

    self.backgroundColor = backdropColor

    super.init(nibName: nil, bundle: nil)

    self.backgroundView.backgroundColor = .clear

    do {

      if usesDismissalPanGestureOnBackdropView {

        let pan = UIPanGestureRecognizer()

        backgroundView.addGestureRecognizer(pan)

        rideauView.register(other: pan)

      }

    }

  }

  @available(*, unavailable)
  required init?(
    coder aDecoder: NSCoder
  ) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Functions

  override func viewDidLoad() {
    super.viewDidLoad()

    do {

      if hidesByBackgroundTouch {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapBackdropView))
        backgroundView.addGestureRecognizer(tap)
      }

      view.addSubview(backgroundView)

      view.backgroundColor = .clear

      backgroundView.frame = view.bounds
      backgroundView.autoresizingMask = [.flexibleHeight, .flexibleWidth]

      view.addSubview(rideauView)
      rideauView.frame = view.bounds
      rideauView.autoresizingMask = [.flexibleHeight, .flexibleWidth]

      // To create resolveConfiguration
      view.layoutIfNeeded()

      set(bodyViewController: bodyViewController, to: rideauView, resizingOption: resizingOption)

      view.layoutIfNeeded()
    }

    rideauView.handlers.willMoveTo = { [weak self] point in

      guard let self else { return }

      guard point == .hidden else {

        UIViewPropertyAnimator(duration: 0.6, dampingRatio: 1) {
          self.backgroundView.backgroundColor = self.backgroundColor
        }
        .startAnimation()

        return
      }

      UIViewPropertyAnimator(duration: 0.6, dampingRatio: 1) {
        self.backgroundView.backgroundColor = .clear
      }
      .startAnimation()

    }

    rideauView.handlers.didMoveTo = { [weak self] point in

      guard let self = self else { return }

      guard point == .hidden else {
        return
      }

      self.onWillDismiss()
      self.onDidDismiss()

    }

  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    onViewDidAppear(self)
  }

  func set(
    bodyViewController: UIViewController,
    to rideauView: RideauView,
    resizingOption: RideauContentContainerView.ResizingOption
  ) {
    bodyViewController.willMove(toParent: self)
    addChild(bodyViewController)
    rideauView.containerView.set(bodyView: bodyViewController.view, resizingOption: resizingOption)
  }

  @objc private dynamic func didTapBackdropView(gesture: UITapGestureRecognizer) {

    rideauView.move(to: .hidden, animated: true, completion: {})

  }
}

#if DEBUG

enum Preview_Rideau: PreviewProvider {

  static var previews: some View {

    Group {
      Stack {

        ZStack {

          StackLink(
            transition: .rideau(),
            destination: {
              ZStack {
                Color.purple
                Text("Hello")
              }

            },
            label: {
              VStack {
                Text("Open")
              }
            }
          )
          
        }

      }
    }

  }

}

#endif
