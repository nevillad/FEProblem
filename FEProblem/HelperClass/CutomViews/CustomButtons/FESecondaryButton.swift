//
//  FESecondaryButton.swift
//  FEProblem
//
//  Created by Nevilkumar Lad on 05/02/22.
//

import UIKit

class FESecondaryButton: FEBaseButton {

    override var isEnabled: Bool {
        didSet {
            self.backgroundColor = isEnabled ? whiteColor : secondaryGrey
        }
    }

    @IBInspectable var showBorder: Bool = false {
        didSet {
            setOutlineBorder(show: showBorder)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSecondaryButton()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSecondaryButton()
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setupSecondaryButton()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView?.tintColor = primaryColor
        self.tintColor = primaryColor
    }

    private func setupSecondaryButton() {
        self.backgroundColor = whiteColor
        self.setTitleColor(primaryColor, for: .normal)
        self.setTitleColor(primaryColor, for: .selected)
        //self.titleFont = Font(.installed(.bold), size: .custom(16)).instance
    }

    private func setOutlineBorder(show: Bool = false) {
        self.layer.borderColor = primaryColor.cgColor
        self.layer.borderWidth = 1
    }
}
