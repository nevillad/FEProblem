//
//  Result.swift
//  FEProblem
//
//  Created by Nevilkumar Lad on 05/02/22.
//

import Foundation

struct Token: Codable {
    var token: String
}

struct Result: Codable {
    var planet_name: String?
    var status: String?
    var error: String?

    enum CodingKeys: String, CodingKey {
        case planet_name
        case status
        case error
    }
}
