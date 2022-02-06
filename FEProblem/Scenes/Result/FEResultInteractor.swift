//
//  FEResultInteractor.swift
//  FEProblem
//
//  Created by Nevilkumar Lad on 04/02/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol FEResultBusinessLogic {
    func doFEResultDetails(request: FEResultModel.FEResultDetails.Request)
    func initialise(showLoader: Bool)
}

protocol FEResultDataStore {
    var destinations: [Destination] { get set }
}

class FEResultInteractor: FEResultBusinessLogic, FEResultDataStore {

    var destinations: [Destination] = []
    
    var presenter: FEResultPresentationLogic?
    var worker: FEResultWorker?
    //var name: String = ""

    // MARK: Do FEResultDetails

    func doFEResultDetails(request: FEResultModel.FEResultDetails.Request)
    {
        worker = FEResultWorker()
        worker?.doSomeWork()

        
    }

    func initialise(showLoader: Bool = true) {
        fetchToken()
    }

    func fetchToken() {
        let finalUrl = FEApiActions.token.urlString
        debugPrint(finalUrl)
        //"https://findfalcone.herokuapp.com/token"
        var resource = Resource<Token>(url: finalUrl)

        resource.httpMethod = HTTPMethod.post
        FENetworkServices.sendRequest(resource: resource) { result in
            switch result {
            case .success(let token):
                debugPrint(token)
                self.fetchResult(token: token.token)
                break
            case .failure(let error):
                self.presenter?.presentError(type: .custom(message: error.localizedDescription))
            }
        }
    }

    func fetchResult(token: String) {
        //self.waitingGroup.enter()
        let finalUrl = FEApiActions.find.urlString
        var resource = Resource<Result>(url: finalUrl)
        var parameters = Parameters()
        parameters["token"] = token
        let planetName = self.destinations.reduce([String](), { newBranch, branch in
            var newBranch = newBranch
            newBranch.append(branch.planet?.name ?? "")
            return newBranch
        })

        let vehicleName = self.destinations.reduce([String](), { newBranch, branch in
            var newBranch = newBranch
            newBranch.append(branch.vehicle?.name ?? "")
            return newBranch
        })
        parameters["planet_names"] = planetName
        parameters["vehicle_names"] = vehicleName
        resource.httpMethod = HTTPMethod.post
        resource.body = parameters
        FENetworkServices.sendRequest(resource: resource) { result in
            switch result {
            case .success(let result):
                var destination: Destination?
                if result.status == "success",let name = result.planet_name {
                    destination = self.destinations.filter{ $0.planet?.name.lowercased() == name.lowercased()}.first
                }
                self.presenter?.presentFEResultDetails(response: FEResultModel.FEResultDetails.Response(result: result, destination: destination))
                break
            case .failure(let error):
                self.presenter?.presentError(type: .custom(message: error.localizedDescription))
            }

        }
    }
}
