//
//  IntrinsicTableView.swift
//  FEProblem
//
//  Created by Nevilkumar Lad on 03/02/22.
//

import UIKit

public class IntrinsicTableView: UITableView {

    public var bottomPadding: CGFloat = 20

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.bounces = false
        registerForLayoutChangeObserver()
    }

    override public var contentSize: CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }

    override public var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height + bottomPadding)
    }

    private func registerForLayoutChangeObserver() {

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reLayout),
                                               name: NotificationName.didLayoutSZTextFieldSubviews.name,
                                               object: nil)
    }

    @objc
    private func reLayout() {
        if self.contentSize.height > 0 {
            self.beginUpdates()
            self.endUpdates()
        }
    }

}
