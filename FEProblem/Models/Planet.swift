//
//  Planet.swift
//  FEProblem
//
//  Created by Nevilkumar Lad on 02/02/22.
//

import Foundation

typealias planets = [Planet]

// MARK: - WelcomeElement
struct Planet: Codable {
    let name: String
    let distance: Int
}


