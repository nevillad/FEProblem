//
//  SZPrimaryButton.swift
//  FEProblem
//
//  Created by Nevilkumar Lad on 04/02/22.
//

import Foundation

import UIKit

class FEPrimaryButton: FEBaseButton {

    override var isEnabled: Bool {
        didSet {
            self.backgroundColor = isEnabled ? primaryColor : secondaryGrey
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPrimaryButton()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupPrimaryButton()
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setupPrimaryButton()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView?.tintColor = whiteColor
        self.tintColor = whiteColor
    }

    private func setupPrimaryButton() {
        self.backgroundColor = primaryColor
        self.setTitleColor(whiteColor, for: .normal)
        self.setTitleColor(whiteColor, for: .selected)
        self.setTitleColor(whiteColor, for: .disabled)

        //self.titleFont = Font(.installed(.bold), size: .custom(16)).instance
    }

}


