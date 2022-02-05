//
//  AppUtility.swift
//  FEProblem
//
//  Created by Nevilkumar Lad on 03/02/22.
//

import Foundation

open class AppUtility: NSObject {

    static var sharedInstance = AppUtility()

    func readLocalMockFile(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name,
                                                 ofType: "json"),
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }
        return nil
    }

    func getDefaultHTTPHeaders() -> HTTPHeaders {
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        return headers
    }

}
