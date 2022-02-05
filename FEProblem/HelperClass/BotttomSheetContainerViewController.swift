//
//  BotttomSheetContainerViewController.swift
//  FEProblem
//
//  Created by Nevilkumar Lad on 03/02/22.
//

import UIKit

let CORNER_RADIUS_BOTTOM_SHEET = CGFloat(16)

public final class BottomSheetView: UIView {
    /// Defines a sizing style for the sheet
    public enum SheetSizingStyle {
        /// Adapts the size of the bottom sheet to its content. If the content height is greater than the available frame height, it pins the sheet to the top safe area inset, like `toSafeAreaTop`.
        case dynamic
        /// Aligns the top of the bottom sheet to the top safe area inset.
        case toSafeAreaTop
        /// Sets a fixed height for the sheet. If `height` is greater than the available frame height, it pins the sheet to the top safe area inset, like `toSafeAreaTop`.
        case fixed(height: CGFloat)
    }

    public enum HandleStyle: CaseIterable {
        /// Hides the handle
        case none
        /// Shows the handle inside the content view
        case inside
        /// Shows the handle on top of the content view
        case outside
    }

    public var handleStyle: HandleStyle = .none {
        willSet {
            setHandle(for: newValue)
            updateHandleConstraints(for: newValue)
            setNeedsDisplay()
        }
    }

    public var sheetSizingStyle: SheetSizingStyle

    /// Ancdhors the top of the `contentView` to its superview
    lazy var contentViewTopAnchor = makeContentViewTopConstraint()
    /// Anchors the top of `contentView` to the bottom of `dragHandle`. Used for `outside` handle style.
    lazy var contentViewTopToHandleAnchor = makeContentTopToHandleConstraint()

    lazy var contentViewLeadingAnchor = contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: contentInsets.left)
    lazy var contentViewTrailingAnchor = contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -contentInsets.right)
    lazy var contentViewBottomAnchor = contentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: bottomInset)

    private lazy var dragHandle: UIView = {
        let view = UIView()
        view.backgroundColor = dragHandleColor
        view.layer.cornerRadius = 2
        return view
    }()

    /// The content of the bottom sheet. Assign your view to this variable to set a custom content.
    public var contentView: UIView = UIView() {
        didSet {
            oldValue.removeFromSuperview()
            addSubview(contentView)

            setHandle(for: handleStyle)
            setContentViewConstraints()
            updateHandleConstraints(for: handleStyle)
        }
    }

    /// The corner radius of the bottom sheet
    public var cornerRadius: CGFloat = CORNER_RADIUS_BOTTOM_SHEET {
        willSet {
            setNeedsDisplay()
        }
    }

    public var handleInset: CGFloat = 12 {
        willSet {
            // Needs to redraw the sheet rectangle
            setNeedsDisplay()
        }
    }

    /// The color of the handle
    public var dragHandleColor: UIColor? { // Color set in system mode
        willSet {
            dragHandle.backgroundColor = newValue
        }
    }

    /// The background color of the content view
    public var contentBackgroundColor: UIColor? {
        willSet {
            setNeedsDisplay()
        }
    }

    public var contentInsets: UIEdgeInsets = .zero {
        didSet {
            updateContentConstraints()
            setNeedsDisplay()
            setNeedsUpdateConstraints()
        }
    }

    private var bottomInset: CGFloat {
        if #available(iOS 11.0, *) {
            return safeAreaInsets.bottom + contentInsets.bottom
        } else {
            // Fallback on earlier versions
            return contentInsets.bottom
        }
    }

    public init(sheetSizingStyle: SheetSizingStyle = .toSafeAreaTop, handleStyle: HandleStyle = .none) {
        self.sheetSizingStyle = sheetSizingStyle
        self.handleStyle = handleStyle
        super.init(frame: .zero)
        setup()
    }

    override init(frame: CGRect) {
        self.sheetSizingStyle = .toSafeAreaTop
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        self.sheetSizingStyle = .toSafeAreaTop
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        backgroundColor = .clear
        if dragHandleColor == nil {
            if #available(iOS 13.0, *) {
                dragHandleColor = .systemFill
            } else {
                dragHandleColor = .white
            }
        }

        if contentBackgroundColor == nil {
            if #available(iOS 13.0, *) {
                contentBackgroundColor = .systemBackground
            } else {
                contentBackgroundColor = .white
            }
        }

        addSubview(contentView)
        setContentViewConstraints()
        setHandle(for: .none)
        updateHandleConstraints(for: handleStyle)
    }

    var handleBottomInset: CGFloat {
        switch handleStyle {
            case .outside: return 12
            default: return 0
        }
    }

    public override func draw(_ rect: CGRect) {
        let handleHeight: CGFloat = handleStyle == .none ? 0 : dragHandle.frame.height
        let topInset: CGFloat = handleStyle == .none ? 0 : handleHeight + handleBottomInset

        let outsideHandleInsets = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
        let rect = handleStyle == .outside ? rect.inset(by: outsideHandleInsets) : rect

        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
        )

        contentBackgroundColor?.setFill()
        path.fill()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

    }

    public override func safeAreaInsetsDidChange() {
        // Need to change the bottom anchor constant because safe area layout guide gets disabled when the frame is moved
        if #available(iOS 11.0, *) {
            if safeAreaInsets.bottom > -contentViewBottomAnchor.constant {
                contentViewBottomAnchor.constant = -bottomInset
                setNeedsUpdateConstraints()
            }
        } else {
            // Fallback on earlier versions
        }
    }

    func makeContentViewTopConstraint() -> NSLayoutConstraint {
        if #available(iOS 11.0, *) {
           return contentView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: contentInsets.top)
        } else {
            // Fallback on earlier versions
           return contentView.topAnchor.constraint(equalTo: readableContentGuide.topAnchor, constant: contentInsets.top)
        }
    }

    func makeContentTopToHandleConstraint() -> NSLayoutConstraint {
        contentView.topAnchor.constraint(equalTo: dragHandle.bottomAnchor, constant: contentInsets.top + handleBottomInset)
    }

    private func updateContentConstraints() {
        contentViewTopAnchor.constant = contentInsets.top
        contentViewTopToHandleAnchor.constant = contentInsets.top + handleBottomInset
        contentViewLeadingAnchor.constant = contentInsets.left
        contentViewTrailingAnchor.constant = -contentInsets.right
        contentViewBottomAnchor.constant = -bottomInset
    }

    private func setContentViewConstraints() {
        contentView.translatesAutoresizingMaskIntoConstraints = false

        contentViewTopAnchor = contentView.topAnchor.constraint(equalTo: topAnchor, constant: contentInsets.top)
        contentViewTopToHandleAnchor = contentView.topAnchor.constraint(equalTo: dragHandle.bottomAnchor, constant: contentInsets.top + handleBottomInset)
        contentViewLeadingAnchor = contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: contentInsets.left)
        contentViewTrailingAnchor = contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -contentInsets.right)
        contentViewBottomAnchor = contentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -bottomInset)

        NSLayoutConstraint.activate([
            contentViewLeadingAnchor,
            contentViewTrailingAnchor,
            contentViewBottomAnchor
        ])
    }

    private func setHandle(for style: HandleStyle) {
        switch style {
            case .none:
                dragHandle.removeFromSuperview()
            case .inside, .outside:
                addSubview(dragHandle)

                dragHandle.translatesAutoresizingMaskIntoConstraints = false

                NSLayoutConstraint.activate([
                    dragHandle.topAnchor.constraint(equalTo: topAnchor, constant: style == .inside ? handleInset : 0),
                    dragHandle.centerXAnchor.constraint(equalTo: centerXAnchor),
                    dragHandle.widthAnchor.constraint(equalToConstant: 40),
                    dragHandle.heightAnchor.constraint(equalToConstant: 4)
                ])
        }

        setNeedsDisplay()
    }

    private func updateHandleConstraints(for style: HandleStyle) {
        switch style {
            case .none:
                contentViewTopAnchor.isActive = true
            case .inside, .outside:
                contentViewTopAnchor.isActive = false
                contentViewTopToHandleAnchor.isActive = true
        }
    }

}

class BotttomSheetContainerViewController: UIViewController, BottomSheetPresenter {
    var bottomSheetTransitioningDelegate = BottomSheetTransitioningDelegate()

    // MARK: Properties
    private let bottomSheetView = BottomSheetView()

    public var sheetSizingStyle: BottomSheetView.SheetSizingStyle {
        get { bottomSheetView.sheetSizingStyle }
        set { bottomSheetView.sheetSizingStyle = newValue }
    }

    public var handleStyle: BottomSheetView.HandleStyle {
        get { bottomSheetView.handleStyle }
        set { bottomSheetView.handleStyle = newValue }
    }

    public var contentView: UIView {
        get { bottomSheetView.contentView }
        set { bottomSheetView.contentView = newValue }
    }

    public var contentBackgroundColor: UIColor {
        get { bottomSheetView.contentBackgroundColor ?? .white }
        set { bottomSheetView.contentBackgroundColor = newValue }
    }

    public var sheetCornerRadius: CGFloat {
        get { bottomSheetView.cornerRadius }
        set { bottomSheetView.cornerRadius = newValue }
    }

    public var contentInsets: UIEdgeInsets {
        get { bottomSheetView.contentInsets }
        set { bottomSheetView.contentInsets = newValue }
    }

    public var viewController: UIViewController?

    // MARK: User defined Methods
    public init(handleStyle: BottomSheetView.HandleStyle = .none, cornerRadius: CGFloat = CORNER_RADIUS_BOTTOM_SHEET) {
        super.init(nibName: nil, bundle: nil)

        self.handleStyle = handleStyle
        self.sheetCornerRadius = cornerRadius

        customInit()
    }

    /// sets modalpresentationstyle and cuotom transitioningDelegate
    private func customInit() {
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = bottomSheetTransitioningDelegate
    }

    // MARK: Override Methods
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        customInit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        customInit()
    }

    /// override this method as view is created manually
    public override func loadView() {
        super.loadView()

        self.view = self.bottomSheetView
        self.bottomSheetView.accessibilityIdentifier = "Bottom_Sheet"

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let viewControllerObj = viewController {
            self.addChild(viewControllerObj)
            self.contentView = viewControllerObj.view
            viewControllerObj.didMove(toParent: self)
        }
    }
}

