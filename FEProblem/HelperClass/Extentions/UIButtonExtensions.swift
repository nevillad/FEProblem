//
//  ButtonExtensions.swift
//  FEProblem
//
//  Created by Nevilkumar Lad on 05/02/22.
//

import UIKit

extension UIButton {
    /// It transforms image from left to rigth
    func setImageToRight() {
        imageEdgeInsets = UIEdgeInsets(top: 5, left: (bounds.width - 40) , bottom: 5, right: 5)//
    }
}
