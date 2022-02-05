//
//  FESecondaryButton.swift
//  FEProblem
//
//  Created by Nevilkumar Lad on 05/02/22.
//

import UIKit

class FESecondaryButton: FEBaseButton {

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
        self.imageView?.tintColor = primaryBurgundy
        self.tintColor = primaryBurgundy
    }

    private func setupSecondaryButton() {
        self.backgroundColor = whiteColor
        self.setTitleColor(primaryBurgundy, for: .normal)
        self.setTitleColor(primaryBurgundy, for: .selected)
        //self.titleFont = Font(.installed(.bold), size: .custom(16)).instance
    }

    private func setOutlineBorder(show: Bool = false) {
        self.layer.borderColor = primaryBurgundy.cgColor
        self.layer.borderWidth = 1
    }
}
