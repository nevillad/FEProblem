//
//  DashboardTableViewCell.swift
//  FEProblem
//
//  Created by Nevilkumar Lad on 03/02/22.
//

import UIKit

let kDashboardTableViewCell_ID = "DashboardTableViewCell"

class DashboardTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var btnSelectPlanet: FEPrimaryButton!
    @IBOutlet weak var btnSelectVehicle: FESecondaryButton!

    @IBOutlet weak var btnClearPlanet: FEPrimaryButton!
    @IBOutlet weak var btnClearVehicle: FEPrimaryButton!


    @IBOutlet weak var lblMissionName: UILabel!

    // Planet Section
    @IBOutlet weak var lblPlanetName: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var ivPlanet: UIImageView!

    // Vehicle Section
    @IBOutlet weak var lblVehicleName: UILabel!
    @IBOutlet weak var lblVehicleSpeed: UILabel!
    @IBOutlet weak var ivVehicle: UIImageView!


    var buttonVehicleSelector: Selector?
    var buttonPlanetSelector: Selector?

    var buttonClearVehicleSelector: Selector?
    var buttonClearPlanetSelector: Selector?

    var buttonTarget: AnyObject?

    fileprivate let selectedColor = UIColor.red.cgColor// Color.secondaryPink100.value


    override func awakeFromNib() {
        super.awakeFromNib()

        self.selectionStyle = .none
        setStyles()
    }

    func setStyles() {
        containerView.addShadow()

        ivPlanet.addShadow()
        ivPlanet.layer.masksToBounds = true
        ivVehicle.addShadow()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }


    func configureCell(item: FEDashboardModel.FEDashboardDetails.ViewModel.DisplayedItem, target: AnyObject?, buttonPlanetSelector: Selector?, buttonVehicleSelector: Selector?, buttonClearVehicleSelector: Selector?, buttonClearPlanetSelector: Selector?) {

        buttonTarget = target

        lblMissionName.text = item.DisplayedMissionName

        lblPlanetName.text = item.DisplayedPlanetName
        lblDistance.text = item.DisplayedPlanetDistance
        ivPlanet.image = UIImage(named: item.DisplayedPlanetImage ?? "")
        ivPlanet.superview?.isHidden = !item.isPlanetVisible
        self.buttonPlanetSelector = buttonPlanetSelector
        self.buttonClearPlanetSelector = buttonClearPlanetSelector
        btnSelectPlanet.tag = item.ItemTag
        btnSelectPlanet.setTitle(item.planetName, for: .normal)
        btnClearPlanet.tag = item.ItemTag

        lblVehicleName.text = item.DisplayedVehicleName
        lblVehicleSpeed.text = item.DisplayedVehicleDistance
        ivVehicle.image = UIImage(named: item.DisplayedVehicleImage ?? "")
        ivVehicle.superview?.isHidden = !item.isVehicleVisible
        self.buttonVehicleSelector = buttonVehicleSelector
        self.buttonClearVehicleSelector = buttonClearVehicleSelector
        btnSelectVehicle.superview?.superview?.isHidden = !item.isVehicleSelectionEnable
        btnSelectVehicle.setTitle(item.vehicleName, for: .normal)
        btnSelectVehicle.tag = item.ItemTag
        btnSelectVehicle.isEnabled = item.isVehicleSelectionEnable
        btnClearVehicle.tag = item.ItemTag

        if let selector = buttonPlanetSelector {
            btnSelectPlanet.addTarget(buttonTarget, action: selector, for: .touchUpInside)
        }

        if let selector = buttonVehicleSelector {
            btnSelectVehicle.addTarget(buttonTarget, action: selector, for: .touchUpInside)
        }

        if let selector = buttonClearPlanetSelector {
            btnClearPlanet.addTarget(buttonTarget, action: selector, for: .touchUpInside)
        }

        if let selector = buttonClearVehicleSelector {
            btnClearVehicle.addTarget(buttonTarget, action: selector, for: .touchUpInside)
        }
    }
}
