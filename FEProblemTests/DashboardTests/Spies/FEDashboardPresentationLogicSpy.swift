//
//  FEDashboardPresentationLogicSpy.swift
//  FEProblemTests
//
//  Created by Nevilkumar Lad on 06/02/22.
//

import Foundation
@testable import FEProblem

class FEDashboardPresentationLogicSpy: FEDashboardPresentationLogic {

    var presentFEDashboardDetailsCalled = false
    var presentNextSceneCalled = false
    var presentLoaderCalled = false
    var presentErrorCalled = false

    var presentFEDashboardDetailsResponse: FEDashboardModel.FEDashboardDetails.Response?

    func presentMissions(response: FEDashboardModel.FEDashboardDetails.Response) {
        presentFEDashboardDetailsCalled = true
        presentFEDashboardDetailsResponse = response
    }

    func presentNextScene(response: FEDashboardModel.NextScene.Response) {

    }

    func presentLoader(type: FEDashboardLoaderType) {

    }

    func hideLoader(type: FEDashboardLoaderType) {

    }

    func presentError(type: FEDashboardErrorType) {

    }


}
