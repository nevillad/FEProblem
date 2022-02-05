//
//  UIViewExtensions.swift
//  FEProblem
//
//  Created by Nevilkumar Lad on 03/02/22.
//

import UIKit

public extension UIView {

    func addBlurEffect(_ alpha: CGFloat = 0.6, gestureRecogniser: UIGestureRecognizer? = nil) {
        let blurEffect = UIBlurEffect(style: .dark)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = self.bounds
        visualEffectView.alpha = alpha
        visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        if let gr = gestureRecogniser {
            visualEffectView.addGestureRecognizer(gr)
        }
        self.addSubview(visualEffectView)
    }

    func removeBlurEffect() {
        subviews.forEach { subview in
            if subview is UIVisualEffectView {
                subview.removeFromSuperview()
            }
        }
    }
    
}



