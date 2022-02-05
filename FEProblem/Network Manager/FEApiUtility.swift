//
//  FEApiUtility.swift
//  FEProblem
//
//  Created by Nevilkumar Lad on 02/02/22.
//

import Foundation

fileprivate let SERVER_URL = "https://findfalcone.herokuapp.com"

public enum FEApiActions: String {
    public enum Dashboard {
        case getPlanets
        case getVehicles
    }
    case token
    case find
}

// MARK: 'Auth'
extension FEApiActions {
    var urlString: String {
        switch self {
        case .token: return SERVER_URL + "/token"
        case .find: return SERVER_URL + "/find"
        }
    }
}

// MARK: 'Dashboard'
extension FEApiActions.Dashboard {
    var urlString: String {
        switch self {
        case .getPlanets: return SERVER_URL + "/planets"
        case .getVehicles: return SERVER_URL + "/vehicles"
        }
    }
}

class FEApiUtility {

    static var shared = FEApiUtility()

    func parseJSON(_ inputData: Data) -> NSDictionary? {
        do {
            let boardsDictionary: NSDictionary = try JSONSerialization.jsonObject(with: inputData, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
            return boardsDictionary

        } catch _ {
            return nil
        }
    }
}

