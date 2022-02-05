//
//  StringExtensions.swift
//  FEProblem
//
//  Created by Nevilkumar Lad on 05/02/22.
//

import Foundation

extension String {
    func isEmpty() -> Bool {
        self.trimmingCharacters(in: .whitespaces).isEmpty
    }
}
