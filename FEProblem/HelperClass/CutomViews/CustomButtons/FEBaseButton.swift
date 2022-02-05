//
//  FEBaseButton.swift
//  FEProblem
//
//  Created by Nevilkumar Lad on 05/02/22.
//

import Foundation

import UIKit

enum ButtonImageAlignment {
    case left
    case right
}

class FEBaseButton: UIButton {

    @IBInspectable var Size: String? {
        willSet {
            //            if let newSize = Font.StandardSize(rawValue: newValue?.lowercased() ?? "") {
            //                self.titleLabel?.font = self.titleLabel?.font.withSize(CGFloat(newSize.value))
            //            }
        }
    }

    @IBInspectable var Weight: String? {
        willSet {
            //            if let newFont = Font.FontName(rawValue: newValue ?? "") {
            //                self.titleLabel?.font = Font(.installed(newFont), size: .custom(Double(self.titleLabel?.font.pointSize ?? 15.0))).instance
            //            }
        }
    }

    @IBInspectable var buttonImage: String? {
        willSet {
            if let newImage = UIImage(named: newValue ?? "") {
                self.setImage(newImage, for: self.state)

            }
        }
    }

    var contentInsets: UIEdgeInsets? {
        didSet {
            if let insets = contentInsets {
                self.contentEdgeInsets = insets
            }
        }
    }

    var imageAlignment: ButtonImageAlignment = .right
    var color: UIColor?
    var titleFont: UIFont?
    var cornerRadius: CGFloat?
    var originalTintColor: UIColor?

    override var isSelected: Bool {
        willSet {
            debugPrint("changing from \(isSelected) to \(newValue)")
            showSelection(isSelected: newValue)
        }
    }

    override func setTitle(_ title: String?, for state: UIControl.State) {
        if let titleText = title {
            super.setTitle(titleText, for: state)
        }
    }

    override func setImage(_ image: UIImage?, for state: UIControl.State) {
        if let buttonImage = image {
            super.setImage(buttonImage, for: state)
            self.setImageToRight()
            if imageAlignment == .right {

            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        if let text = self.titleLabel?.text {
            let langText = text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            setTitle(langText, for: .normal)
        }
        setupView()
    }

    override func draw(_ rect: CGRect) {
        originalTintColor = self.imageView?.tintColor
        setupView()
    }

    override internal func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    private func setupView() {
        showSelection(isSelected: isSelected)
        self.layer.cornerRadius = cornerRadius ?? 8.0
        self.clipsToBounds = true

        if Size ==  nil || Weight == nil {
            //self.titleLabel?.font = titleFont ?? Font(.installed(.medium), size: .standard(.h4)).instance
        }

        if let color = color {
            self.setTitleColor(color, for: .selected)
        }

        self.imageView?.contentMode = .scaleAspectFit
        if let string = self.buttonImage,
           !string.isEmpty(),
           let image = UIImage(named: string) {
            self.setImage(image, for: .normal)
            self.setImage(image, for: .selected)
            self.setImage(image, for: .disabled)
        } else {
            // to add padding and increase the intrinsic size of the button
            self.contentEdgeInsets = contentInsets ?? UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
        }
    }

    func showSelection(isSelected: Bool) {
        if isSelected {
        } else {
        }
    }

}
