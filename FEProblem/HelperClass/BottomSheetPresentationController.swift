//
//  BottomSheetPresentationController.swift
//  FEProblem
//
//  Created by Nevilkumar Lad on 03/02/22.
//

import UIKit

public protocol BottomSheetPresenter: class {
    var bottomSheetTransitioningDelegate: BottomSheetTransitioningDelegate { get }
}

/// `BottomSheetTransitioningDelegate`: This will manages the transition animations and the presentation of `BotttomSheetContainerViewController` onscreen. This will replace default `UIPresentationController` with `BottomSheetPresentationController`.
public final class BottomSheetTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        guard let presentedController = presented as? BotttomSheetContainerViewController else { return nil }
        return BottomSheetPresentationController(presentedViewController: presentedController, presenting: presenting)
    }
}

class BottomSheetPresentationController: UIPresentationController {
    private var presentedViewCenter: CGPoint = .zero

    /// It handles the blur intensity of `blurEffectView`
    private lazy var blurView = UIView(frame: CGRect.zero)

    private lazy var blurEffectView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: effect)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        view.addGestureRecognizer(gesture)
        return view
    }()

    private lazy var panGesture: UIPanGestureRecognizer = {
        UIPanGestureRecognizer(target: self, action: #selector(drag(_:)))
    }()

    /// The style of the bottom sheet
    var sheetSizingStyle: BottomSheetView.SheetSizingStyle {
        guard let presentedController = presentedViewController as? BotttomSheetContainerViewController else { return .toSafeAreaTop }
        return presentedController.sheetSizingStyle
    }

    public override var frameOfPresentedViewInContainerView: CGRect {
        switch sheetSizingStyle {
        case .dynamic: return dynamicFrame
        case .toSafeAreaTop: if #available(iOS 11.0, *) {
            return toSafeAreaTopFrame
        } else {
            // Fallback on earlier versions
            return .zero
        }
        case .fixed(let height): return fixedFrame(height)
        }
    }

    private var dynamicFrame: CGRect {
        guard let containerView = containerView, let presentedView = presentedView else { return .zero }

        var safeAreaFrame = containerView.bounds
        if #available(iOS 11.0, *) {
            safeAreaFrame = containerView.bounds.inset(by: containerView.safeAreaInsets)
        }

        let targetWidth = safeAreaFrame.width
        // Fitting size for auto layout
        let fittingSize = CGSize(width: targetWidth, height: UIView.layoutFittingCompressedSize.height)
        var targetHeight = presentedView.systemLayoutSizeFitting(fittingSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .defaultLow).height

        // Handle cases when the containerView does not use auto layout
        if let tableView = presentedView.subviews.first(where: { $0 is UITableView }) as? UITableView {
            targetHeight += tableView.contentSize.height
        }
        if let tableView = presentedView as? UITableView {
            targetHeight += tableView.contentSize.height
        }
        if let collectionView = presentedView.subviews.first(where: { $0 is UICollectionView }) as? UICollectionView {
            targetHeight += collectionView.contentSize.height
        }
        if let collectionView = presentedView as? UICollectionView {
            targetHeight += collectionView.contentSize.height
        }

        // Add the bottom safe area inset
        if #available(iOS 11.0, *) {
            targetHeight += containerView.safeAreaInsets.bottom
        } else {
            // Fallback on earlier versions
        }

        var frame = safeAreaFrame
        frame.origin.y += frame.size.height - targetHeight
        frame.size.width = targetWidth
        frame.size.height = targetHeight

        if #available(iOS 11.0, *) {
            if frame.height > toSafeAreaTopFrame.height {
                return toSafeAreaTopFrame
            }
        } else {
            // Fallback on earlier versions
        }
        return frame
    }

    @available(iOS 11.0, *)
    private var toSafeAreaTopFrame: CGRect {
        guard let containerView = containerView else { return .zero }

        let safeAreaFrame = containerView.bounds.inset(by: containerView.safeAreaInsets)
        let targetWidth = safeAreaFrame.width

        var frame = safeAreaFrame
        frame.origin.y += containerView.safeAreaInsets.bottom
        frame.size.width = targetWidth
        return frame
    }

    private func fixedFrame(_ height: CGFloat) -> CGRect {
        guard let containerView = containerView else { return .zero }
        var safeAreaFrame = containerView.bounds
        if #available(iOS 11.0, *) {
            safeAreaFrame = containerView.bounds.inset(by: containerView.safeAreaInsets)
        }
        let targetWidth = safeAreaFrame.width

        var frame = safeAreaFrame
        if #available(iOS 11.0, *) {
            frame.origin.y += containerView.safeAreaInsets.bottom
        } else {
            frame.origin.y += containerView.frame.maxY
            // Fallback on earlier versions
        }
        frame.size.width = targetWidth
        frame.size.height = height

        if #available(iOS 11.0, *) {
            if frame.height > toSafeAreaTopFrame.height {
                return toSafeAreaTopFrame
            }
        } else {
            // Fallback on earlier versions
        }
        return frame
    }

    public init(presentedViewController: BotttomSheetContainerViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }

    // MARK: Override `UIPresentationController` methods
    public override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()

        guard let presentedView = presentedView else { return }

        presentedView.layer.masksToBounds = true
        presentedView.roundCorners(corners: [.topLeft, .topRight], radius: 0)
        presentedView.isUserInteractionEnabled = true

        if !(presentedView.gestureRecognizers?.contains(panGesture) ?? false) {
            presentedView.addGestureRecognizer(panGesture)
        }
    }

    public override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()

        guard let presenterView = containerView else { return }
        guard let presentedView = presentedView else { return }

        presentedView.frame = frameOfPresentedViewInContainerView
        presentedView.backgroundColor = UIColor.clear

        let gap = presenterView.bounds.height - frameOfPresentedViewInContainerView.height
        presentedView.center = CGPoint(x: presenterView.center.x, y: presenterView.center.y + gap / 2)
        presentedViewCenter = presentedView.center

        self.blurView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        self.blurView.frame = presenterView.bounds
        self.blurEffectView.frame = presenterView.bounds
    }

    public override func presentationTransitionWillBegin() {
        self.blurEffectView.alpha = 0
        self.blurView.alpha = 0

        guard let presenterView = containerView else { return }

        //presenterView.addSubview(self.blurView)
        presenterView.addBlurEffect(gestureRecogniser: UITapGestureRecognizer(target: self, action: #selector(dismiss)))

        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] context in
            self?.blurEffectView.alpha = 1
            self?.blurView.alpha = 0.3
        }, completion: nil)
    }

    public override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] context in
            self?.blurView.alpha = 0
            self?.blurEffectView.alpha = 0
        }, completion: { [weak self] context in
            self?.blurEffectView.removeFromSuperview()
            self?.blurView.removeFromSuperview()
        })
    }

    @objc private func dismiss() {
        guard let presenterView = containerView else { return }
        presenterView.removeBlurEffect()
        presentedViewController.dismiss(animated: true, completion: nil)
    }

    @objc private func drag(_ gesture: UIPanGestureRecognizer) {
        guard let presentedView = presentedView, let presenterView = containerView else { return }

        switch gesture.state {
        case .changed:
            presentingViewController.view.bringSubviewToFront(presentedView)
            let translation = gesture.translation(in: presentingViewController.view)
            let y = presentedView.center.y + translation.y

            let gap = presenterView.bounds.height - presentedView.frame.height
            let shouldBounce = y - gap / 2 > presentingViewController.view.center.y

            if shouldBounce {
                presentedView.center = CGPoint(x: presentedView.center.x, y: y)
            }

            gesture.setTranslation(.zero, in: presentingViewController.view)

        case .ended:
            let height = presentingViewController.view.frame.height
            let position = presentedView.convert(presentingViewController.view.frame, to: nil).origin.y

            let velocity = gesture.velocity(in: presentedView)
            let targetVelocityHeight = presentedView.frame.height * 2
            let targetDragHeight = presentedView.frame.height * 3 / 4

            if velocity.y > targetVelocityHeight || height - position < targetDragHeight {
                dismiss()
            } else {
                restorePosition()
                restoreDimming()
            }

            gesture.setTranslation(.zero, in: presentingViewController.view)
        default:
            break
        }
    }

    private func restorePosition() {
        guard let presentedView = presentedView else { return }

        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self = self else { return }
            presentedView.center = self.presentedViewCenter
        }
    }

    private func restoreDimming() {
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self = self else { return }
            self.blurEffectView.alpha = 1.0
            self.blurView.alpha = 0.3
        }
    }
}

extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
