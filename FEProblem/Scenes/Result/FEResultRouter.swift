//
//  FEResultRouter.swift
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

@objc protocol FEResultRoutingLogic {
    func showNextScene()
}

protocol FEResultDataPassing {
    var dataStore: FEResultDataStore? { get }
}

class FEResultRouter: NSObject, FEResultRoutingLogic, FEResultDataPassing {
    weak var viewController: FEResultViewController?
    var dataStore: FEResultDataStore?

    // MARK: Navigation
    func showNextScene() {

    }
}

// MARK: Passing data
extension FEResultRouter {

    /*
    func passDataTo(_ destinationDS: inout <destinationDataStore>?, from sourceDS: FEResultDataStore?) {

    }
    */
}
