//
//  FEDashboardModels.swift
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

enum SelectionType {
    case selectPlanet
    case selectVehicle
    case showResult
    case showSubmit
}

enum FEDashboardLoaderType {
    case general
}

enum FEDashboardErrorType {
    case backend
    case custom(message: String)
}

enum FEDashboardModel {
    // MARK: Use cases
    
    enum FEDashboardDetails {
        struct Request {
        }
        struct Response {
            var destinations: [Destination]
        }
        struct ViewModel {
            struct DisplayedItem {
                
                var DisplayedMissionName: String?
                
                var DisplayedPlanetName: String?
                var DisplayedPlanetDistance: String?
                var DisplayedPlanetImage: String?
                var isPlanetVisible: Bool = false
                
                var DisplayedVehicleName: String?
                var DisplayedVehicleDistance: String?
                var DisplayedVehicleImage: String?
                var isVehicleVisible: Bool = false
                var isVehicleSelectionEnable: Bool = false
                
                var planetName: String
                var vehicleName: String
                var ItemTag: Int
                
            }
            var displayingDestination: [DisplayedItem]
        }
    }
    
    enum FEDashboardDestinationSelection {
        struct Request {
            var selectionType: SelectionType
            var selectedID: Int
        }
        
        
        struct Response {
            var destinations: [Destination]
        }
        struct ViewModel {
            struct DisplayedItem {
                var planetName: String
                var vehicleName: String
                var ItemTag: Int
            }
            var displayingDestination: [DisplayedItem]
        }
    }
    
    enum FEDashboardSetOption {
        struct Request {
            var selectionType: SelectionType
            var selectedID: Int64
        }
        
        struct Response {
            
        }
        struct ViewModel {
            
        }
    }
    
    enum NextScene {
        struct Request {
        }
        
        struct Response {
            var selectionType: SelectionType
            var isViewNextVisible: Bool = false
        }
        
        struct ViewModel {
            var selectionType: SelectionType
            var isViewNextVisible: Bool = false
        }
    }
}



