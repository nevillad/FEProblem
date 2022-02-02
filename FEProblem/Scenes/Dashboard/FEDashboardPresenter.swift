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
    func presentFEDashboardDetails(response: FEDashboardModel.FEDashboardDetails.Response)
    func presentNextScene(response: FEDashboardModel.NextScene.Response)
    func presentLoader(type: FEDashboardLoaderType)
    func hideLoader(type: FEDashboardLoaderType)
    func presentError(type: FEDashboardErrorType)
}

class FEDashboardPresenter: FEDashboardPresentationLogic {
    weak var viewController: FEDashboardDisplayLogic?

    // MARK: Do FEDashboardDetails

    func presentFEDashboardDetails(response: FEDashboardModel.FEDashboardDetails.Response) {
        let viewModel = FEDashboardModel.FEDashboardDetails.ViewModel()
        viewController?.displayFEDashboardDetails(viewModel: viewModel)
    }

    func presentNextScene(response: FEDashboardModel.NextScene.Response) {
        let viewModel = FEDashboardModel.NextScene.ViewModel()
        viewController?.displayNextScene(viewModel: viewModel)
    }

    func presentLoader(type: FEDashboardLoaderType) {
        viewController?.displayLoader(type: type)
    }

    func hideLoader(type: FEDashboardLoaderType) {
        viewController?.hideLoader(type: type)
    }

    func presentError(type: FEDashboardErrorType) {
        viewController?.displayError(type: type)
    }
}