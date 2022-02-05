//
//  Vehicle.swift
//  FEProblem
//
//  Created by Nevilkumar Lad on 02/02/22.
//

import Foundation

// MARK: - Vehicle
class Vehicle: Codable {
    let name: String
    let totalNo, maxDistance, speed: Int
    var _id: Int64? = Date.currentTimeStamp
    var selectedCount: Int? = 0

    enum CodingKeys: String, CodingKey {
        case name
        case totalNo = "total_no"
        case maxDistance = "max_distance"
        case speed
        case _id
        case selectedCount
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try values.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.totalNo = try values.decodeIfPresent(Int.self, forKey: .totalNo) ?? 0
        self.maxDistance = try values.decodeIfPresent(Int.self, forKey: .maxDistance) ?? 0
        self.speed = try values.decodeIfPresent(Int.self, forKey: .speed) ?? 0
        self._id = try values.decodeIfPresent(Int64.self, forKey: ._id) ?? Date.currentTimeStamp
    }

    
}

typealias vehicles = [Vehicle]
