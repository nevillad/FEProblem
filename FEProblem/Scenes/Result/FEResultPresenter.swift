//
//  FEResultPresenter.swift
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

protocol FEResultPresentationLogic {
    func presentFEResultDetails(response: FEResultModel.FEResultDetails.Response)
    func presentError(type: FEResultErrorType)
}

class FEResultPresenter: FEResultPresentationLogic {
    weak var viewController: FEResultDisplayLogic?

    // MARK: Do FEResultDetails

    func presentFEResultDetails(response: FEResultModel.FEResultDetails.Response) {
        var message = ""
        var missionStatus: String? = "mission_success"

        if response.result.status == "success" {
            message = "SUCCESS!!\nCongratulations 🎉 on finding Falcone!\nKING🤴Khan is mighty pleased!😺\n\nFound on planet (\(response.destination?.planet?.name ?? "")) with the help of \(response.destination?.vehicle?.name ?? "")"
        } else if response.result.status == "false" {
            message = "Mission Failed!!\nPlease Try Again!"
            missionStatus = "mission_fail"
        } else if let error = response.result.error {
            message = "Mission Aborted!!\n\(error)"
            missionStatus = "mission_error"
        }

        let viewModel = FEResultModel.FEResultDetails.ViewModel(message: message, missionImage: missionStatus)
        viewController?.displayFEResultDetails(viewModel: viewModel)
    }

    func presentError(type: FEResultErrorType) {
        viewController?.displayError(type: type)
    }
}
