//
//  FEApiUtility.swift
//  FEProblem
//
//  Created by Nevilkumar Lad on 02/02/22.
//

import Foundation

fileprivate let SERVER_URL = "https://findfalcone.herokuapp.com"
fileprivate let AUTH_SERVER_URL = "https://oauth.api.dev.axisb.com"


public enum FEApiActions: String {
    // api's to carry out authentication
    public enum Auth {
        case handshake
    }

    public enum Dashboard {
        case getPlanets
        case getVehicles
    }


    case fetchBanners
    case fetchFaqs
    case draftApplication
    case generateLeads
}

// MARK: 'Auth'
extension FEApiActions.Auth {
    var urlString: String {
        switch self {
        case .handshake: return AUTH_SERVER_URL + "/auth/handshake"
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

//    func getDefaultHTTPHeaders() -> HTTPHeaders {
//        // NOTE: app crashes if no bundle versions are set for the current target
//        guard let bundleVersion = Bundle.main.infoDictionary!["CFBundleVersion"] as? String else {
//            fatalError("Could not get app bundle version.")
//        }
//
//        var headers: HTTPHeaders = [
//            "DeviceType":  CONST_DEVICE_TYPE,
//            "Version": bundleVersion,
//            "App": AppUtility.sharedInstance.appDetails.appName,
//            "languagecode": CONST_LANGUAGE_CODE,
//            "Content-Type": "application/json",
//            "x-api-key": API_KEY_iOS
//        ]
//
//        let accessToken = SecurityUtility.shared.getAuthToken()
//        if !accessToken.isEmpty() {
//            headers["x-access-token"] = accessToken
//        }
//        return headers
//    }


    func parseJSON(_ inputData: Data) -> NSDictionary? {
        do {
            let boardsDictionary: NSDictionary = try JSONSerialization.jsonObject(with: inputData, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
            return boardsDictionary

        } catch _ {
            return nil
        }
    }
}

