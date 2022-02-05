//
//  Planet.swift
//  FEProblem
//
//  Created by Nevilkumar Lad on 02/02/22.
//

import Foundation

typealias planets = [Planet]

// MARK: - Planet
class Planet: Codable {
    let name: String
    let distance: Int
    var _id: Int64? = Date.currentTimeStamp
    var isSelected: Bool? = false
    enum CodingKeys: String, CodingKey {
        case name
        case distance
        case _id
        case isSelected
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try values.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.distance = try values.decodeIfPresent(Int.self, forKey: .distance) ?? 0
        self._id = try values.decodeIfPresent(Int64.self, forKey: ._id) ?? Date.currentTimeStamp
        self.isSelected = try values.decodeIfPresent(Bool.self, forKey: .isSelected) ?? false
    }

     func setSelected(value: Bool) {
        self.isSelected = value
    }
}


