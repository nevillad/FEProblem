//
//  Destination.swift
//  FEProblem
//
//  Created by Nevilkumar Lad on 05/02/22.
//

import Foundation

class Destination: Codable {
    var title: String?
    var subTitle: String?
    var tag: Int?
    var planet: Planet?
    var vehicle: Vehicle?

    enum CodingKeys: String, CodingKey {
        case title
        case subTitle
        case tag
        case planet
        case vehicle
    }
}
