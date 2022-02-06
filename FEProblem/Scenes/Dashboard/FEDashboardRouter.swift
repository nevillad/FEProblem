//
//  FEDashboardRouter.swift
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

protocol FEDashboardRoutingLogic {
    func showNextScene(screenSelection: SelectionType)
}

protocol FEDashboardDataPassing {
    var dataStore: FEDashboardDataStore? { get }
}

class FEDashboardRouter: NSObject, FEDashboardRoutingLogic, FEDashboardDataPassing {
    weak var viewController: FEDashboardViewController?
    var dataStore: FEDashboardDataStore?

    // MARK: Navigation
    func showNextScene(screenSelection: SelectionType) {
        switch screenSelection {
        case .selectPlanet: showOptionsPopup(screenSelection: screenSelection)
        case .selectVehicle: showOptionsPopup(screenSelection: screenSelection)
        case .showResult:showResultScreen()
        case .showSubmit: break
        }
    }

    func showOptionsPopup(screenSelection: SelectionType) {
        let bottomSheetContentView = ListOptionsViewController.instantiateFromStoryboard()
        bottomSheetContentView.delegate = viewController
        var destinationDS = bottomSheetContentView.router?.dataStore
        passDataTo(&destinationDS, from: dataStore, selectionType: screenSelection )

        let controller = BotttomSheetContainerViewController()
        controller.viewController = bottomSheetContentView
        controller.sheetCornerRadius = 16
        controller.sheetSizingStyle = .dynamic
        controller.handleStyle = .inside
        controller.contentInsets = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
        viewController?.present(controller, animated: true, completion: nil)
    }

    func showResultScreen(){
        let resultVC = FEResultViewController.instantiateFromStoryboard()
        var destinationDS = resultVC.router?.dataStore
        passDataTo(&destinationDS, from: dataStore)

        viewController?.navigationController?.pushViewController(resultVC, animated: true)
    }
}

// MARK: Passing data
extension FEDashboardRouter {

    // MARK: Passing data
    func passDataTo(_ destinationDS: inout ListOptionsDataStore?, from sourceDS: FEDashboardDataStore?, selectionType: SelectionType) {
        destinationDS?.selectionType = selectionType
        destinationDS?.selectedDestination = sourceDS?.selectedDestination
        destinationDS?.items = sourceDS?.filtredPlanetsOption ?? []
        if selectionType == .selectVehicle {
            destinationDS?.items = sourceDS?.filtredVehiclesOption ?? []
        }
    }

    func passDataTo(_ destinationDS: inout FEResultDataStore?, from sourceDS: FEDashboardDataStore?) {
        destinationDS?.destinations = sourceDS?.destinations ?? []
    }
}
