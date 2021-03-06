//
//  FEDashboardPresenter.swift
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

protocol FEDashboardPresentationLogic {
    func presentMissions(response: FEDashboardModel.FEDashboardDetails.Response)
    func presentNextScene(response: FEDashboardModel.NextScene.Response)
    func presentLoader(type: FEDashboardLoaderType)
    func hideLoader(type: FEDashboardLoaderType)
    func presentError(type: FEDashboardErrorType)
}

class FEDashboardPresenter: FEDashboardPresentationLogic {
    weak var viewController: FEDashboardDisplayLogic?

    // MARK:- Implement Presentation Logic


    /**
     Presentation Logic for Falcone missions/destinations
     - Based on response create DisplayItem for mission
     -
     */
    func presentMissions(response: FEDashboardModel.FEDashboardDetails.Response) {
        var listItem: [FEDashboardModel.FEDashboardDetails.ViewModel.DisplayedItem] = []

        /// Loop itration for creatng DisplayItem Based on reponse model
        for destination in response.destinations {

            ///
            let DisplayMissionName = destination.title
            let DisplayPlanetName = "Planet: \(destination.planet?.name.uppercased() ?? "")"
            let DisplayPlanetDistance = "Distance \(destination.planet?.distance ?? 0) megamiles"

            /// Using plane name as image name
            let DisplayPlanetImage = destination.planet?.name.lowercased()
            /// Setting visibilit of planet
            let isPlanetVisible = !(destination.planet == nil)

            let DisplayVehicleName = destination.vehicle?.name.uppercased()
            let DisplayVehicleDistance = "Unit(\(destination.vehicle?.totalNo ?? 0)), Max Distance\(destination.vehicle?.maxDistance ?? 0) megamiles"

            /// Using vehicle name as image name
            let DisplayVehicleImage = destination.vehicle?.name.lowercased()
            /// Setting visibilit of vehicle
            let isVehicleVisible = !(destination.vehicle == nil)


            /// Enabling/Disabling selection of vehicle only if planet is selected
            let isVehicleSelectionEnable = !(destination.planet == nil)

            /// Planet Seletion Button Title
            let planetName = destination.planet != nil ? "Change Planet" : "Select Planet"

            /// Vehicle Seletion Button Title
            let vehicleName = destination.vehicle != nil ? "Change Vehicle" : "Select Vehicle"

            let ItemTag = destination._id ?? 0

            // Creating DisplayedItem based on response model data
            let item = FEDashboardModel.FEDashboardDetails.ViewModel.DisplayedItem(DisplayedMissionName: DisplayMissionName,
                                                                                   DisplayedPlanetName: DisplayPlanetName,
                                                                                   DisplayedPlanetDistance: DisplayPlanetDistance,
                                                                                   DisplayedPlanetImage: DisplayPlanetImage,
                                                                                   isPlanetVisible: isPlanetVisible,
                                                                                   DisplayedVehicleName: DisplayVehicleName,
                                                                                   DisplayedVehicleDistance: DisplayVehicleDistance,
                                                                                   DisplayedVehicleImage: DisplayVehicleImage,
                                                                                   isVehicleVisible: isVehicleVisible,
                                                                                   isVehicleSelectionEnable: isVehicleSelectionEnable,
                                                                                   planetName: planetName,
                                                                                   vehicleName: vehicleName,
                                                                                   ItemTag: ItemTag)

            // Appending item into list
            listItem.append(item)

        }

        // Preparing ViewModel for Missions List
        let viewModel = FEDashboardModel.FEDashboardDetails.ViewModel(displayingDestination: listItem)
        viewController?.displayMissions(viewModel: viewModel)
    }

    /**
     Presentation Logic for showing Next screen e.g Result, Vehicle/Palnet Selection
     */
    func presentNextScene(response: FEDashboardModel.NextScene.Response) {
        let viewModel = FEDashboardModel.NextScene.ViewModel(selectionType: response.selectionType, isViewNextVisible: response.isViewNextVisible)
        viewController?.displayNextScene(viewModel: viewModel)
    }


    /**
     Presenting loading messages
     */
    func presentLoader(type: FEDashboardLoaderType) {
        viewController?.displayLoader(type: type)
    }

    /**
     Hideing messages
     */
    func hideLoader(type: FEDashboardLoaderType) {
        viewController?.hideLoader(type: type)
    }

    /**
     Show Error Messages
     */
    func presentError(type: FEDashboardErrorType) {
        viewController?.displayError(type: type)
    }
}
