//
//  DateEtentions.swift
//  FEProblem
//
//  Created by Nevilkumar Lad on 05/02/22.
//

import Foundation

extension Date {
    static var currentTimeStamp: Int64 {
        return Int64(Date().timeIntervalSince1970 * 10000000)
    }
}

