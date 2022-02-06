//
//  AppConstant.swift
//  FEProblem
//
//  Created by Nevilkumar Lad on 02/02/22.
//

import Foundation
import UIKit

let SOMETHING_WENT_WRONG = "something went wrong"
let kDateTime = "DateTime"

// Constant Variables
public let kCornerRadius: CGFloat = 8

public let primaryColor = UIColor.black
public let secondaryColor = UIColor.yellow

//public let primaryBurgundy = UIColor.systemPink// Color.secondaryPink100.value
public let secondaryGrey = UIColor.lightGray
public let secondaryLightGrey = UIColor.systemGray3 // Color.secondaryGrey50.value
public let secondaryLightGrey2 = UIColor.systemGray6
public let whiteColor = UIColor.white


enum NotificationName: String {
    case didSelectDropDownValue
    case isIndianTaxPayer
    case nextButtonVisisbilty
    case didLayoutSZTextFieldSubviews

    enum Nominee: String {
        case show
        case edit
        case remove
    }

    enum VideoKYC: String {
        case status
    }

    var name: Notification.Name {
        return Notification.Name(self.rawValue)
    }
}

