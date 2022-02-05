//
//  FEDashboardInteractor.swift
//  FEProblem
//
//  Created by Nevilkumar Lad on 02/02/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol FEDashboardBusinessLogic {
    func doFEDashboardDetails(request: FEDashboardModel.FEDashboardDetails.Request)
    func initialise(showLoader: Bool)
    func selectDestination(request: FEDashboardModel.FEDashboardDestinationSelection.Request)
    func setOption(request: FEDashboardModel.FEDashboardSetOption.Request)
}

protocol FEDashboardDataStore {
    var filtredPlanetsOption: planets { get set }
    var filtredVehiclesOption: vehicles { get set }

    var planets: planets { get set }
    var vehicles: vehicles { get set }
    var selectedVehicle: Vehicle? { get set }
    var selectedPlanet: Planet? { get set }
    var selectedDestination: Destination? { get set }
    var destinations: [Destination] { get set }

}

class FEDashboardInteractor: FEDashboardBusinessLogic, FEDashboardDataStore {
    var presenter: FEDashboardPresentationLogic?
    var worker: FEDashboardWorker?
    //var name: String = ""
    var waitingGroup = DispatchGroup()

    internal var planets: planets = []
    internal var vehicles: vehicles = []
    internal var selectedPlanet: Planet?
    internal var selectedVehicle: Vehicle?
    internal var selectedDestination: Destination?

    var filtredVehiclesOption: vehicles = []
    var filtredPlanetsOption: planets = []


    internal var destinations: [Destination] = []

    // MARK: Do FEDashboardDetails

    func doFEDashboardDetails(request: FEDashboardModel.FEDashboardDetails.Request) {
        worker = FEDashboardWorker()
        // let response = FEDashboardModel.FEDashboardDetails.Response()
        // presenter?.presentFEDashboardDetails(response: response)
    }

    func initialise(showLoader: Bool = true) {
        fetchPlanets()
        fetchVehicles()
        waitingGroup.notify(queue: .main) {
            debugPrint(self.planets)
            debugPrint(self.vehicles)
            self.worker = FEDashboardWorker()
            if let destination = self.worker?.getDestination() {
                self.destinations = destination
                self.presenter?.presentFEDashboardDetails(response: FEDashboardModel.FEDashboardDetails.Response(destinations: self.destinations))
            }
        }
    }

    func selectDestination(request: FEDashboardModel.FEDashboardDestinationSelection.Request) {
        if let destination = self.destinations.filter({ $0.tag == request.selectedID }).first {
            self.selectedDestination = destination
            self.filtredVehiclesOption = self.vehicles.filter { $0.totalNo > $0.selectedCount ?? 0 || $0._id == destination.vehicle?._id }
            self.filtredPlanetsOption = self.planets.filter({ $0.isSelected == false || ($0.isSelected == true && $0._id == destination.planet?._id) })
            presenter?.presentNextScene(response: FEDashboardModel.NextScene.Response(selcctType: request.selcctType))
        }
    }

    func setOption(request: FEDashboardModel.FEDashboardSetOption.Request) {
        if request.selcctType == .selectVehicle, let vehicle = self.vehicles.filter { $0._id  == request.selectedID}.first {
            self.selectedDestination?.vehicle?.selectedCount! -= 1
            self.selectedDestination?.vehicle = vehicle
            vehicle.selectedCount! += 1
        } else if request.selcctType == .selectPlanet,let planet = self.planets.filter({ $0._id  == request.selectedID}).first {
            self.selectedDestination?.planet?.setSelected(value: false)
            planet.setSelected(value: true)
            self.selectedDestination?.planet = planet
        }

        self.presenter?.presentFEDashboardDetails(response: FEDashboardModel.FEDashboardDetails.Response(destinations: self.destinations))

    }

    func fetchPlanets() {
        let finalUrl = FEApiActions.Dashboard.getPlanets.urlString
        let resource = Resource<planets>(url: finalUrl)
        debugPrint("Final url is: \(resource.url)")

        waitingGroup.enter()
        FENetworkServices.shared.fetchJson(resource: resource) { result in
            self.presenter?.hideLoader(type: .general)
            switch result {
            case .success(let planets):
                self.planets = planets
                break
            case .failure(let error):
                self.presenter?.presentError(type: .custom(message: error.localizedDescription))
            }
            self.waitingGroup.leave()
        }
    }

    func fetchVehicles() {
        let finalUrl = FEApiActions.Dashboard.getVehicles.urlString
        let resource = Resource<vehicles>(url: finalUrl)
        debugPrint("Final url is: \(resource.url)")

        waitingGroup.enter()
        FENetworkServices.shared.fetchJson(resource: resource) { result in
            self.presenter?.hideLoader(type: .general)
            switch result {
            case .success(let vehicles):
                self.vehicles = vehicles
                break
            case .failure(let error):
                self.presenter?.presentError(type: .custom(message: error.localizedDescription))
            }
            self.waitingGroup.leave()
        }
    }
}
