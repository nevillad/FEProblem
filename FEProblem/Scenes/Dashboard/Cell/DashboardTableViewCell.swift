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
    var buttonTarget: AnyObject?

    fileprivate let selectedColor = UIColor.red.cgColor// Color.secondaryPink100.value


    override func awakeFromNib() {
        super.awakeFromNib()

        self.selectionStyle = .none
        setStyles()

        // Initialization code
    }

    func setStyles() {
        containerView.layer.borderColor = secondaryLightGrey.cgColor
        containerView.layer.borderWidth = 1.0
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = kCornerRadius
        containerView.layer.masksToBounds = false
        containerView.layer.shadowColor = secondaryLightGrey.cgColor
        containerView.layer.shadowOpacity = 1
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        containerView.layer.shadowRadius = 4

        ivPlanet.layer.cornerRadius = 5.0
        // border
        ivPlanet.layer.borderColor = UIColor.lightGray.cgColor
        ivPlanet.layer.borderWidth = 0.5

        // drop shadow
        ivPlanet.layer.shadowColor = UIColor.black.cgColor
        ivPlanet.layer.shadowOpacity = 0.8
        ivPlanet.layer.shadowRadius = 3.0
        ivPlanet.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)

        ivVehicle.layer.cornerRadius = 5.0
        // border
        ivVehicle.layer.borderColor = UIColor.lightGray.cgColor
        ivVehicle.layer.borderWidth = 0.5

        // drop shadow
        ivVehicle.layer.shadowColor = UIColor.black.cgColor
        ivVehicle.layer.shadowOpacity = 0.8
        ivVehicle.layer.shadowRadius = 3.0
        ivVehicle.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)

    }

//    func setGradientBackground() {
//        let colorTop =  Color.tertiaryAquaDeep20.value.cgColor
//        let colorBottom = Color.tertiaryAquaDeep20.value.withAlphaComponent(0.1).cgColor
//
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.colors = [colorTop, colorBottom]
//        gradientLayer.locations = [0.0, 1.0]
//        gradientLayer.frame = self.viewCardDetails.bounds
//
//        self.viewCardDetails.layer.insertSublayer(gradientLayer, at:0)
//        self.viewCardDetails.clipsToBounds = true
//    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }


    func configureCell(item: FEDashboardModel.FEDashboardDetails.ViewModel.DisplayedItem, target: AnyObject?, buttonPlanetSelector: Selector?, buttonVehicleSelector: Selector? ) {

        lblMissionName.text = item.DisplayedMissionName

        lblPlanetName.text = item.DisplayedPlanetName
        lblDistance.text = item.DisplayedPlanetDistance
        ivPlanet.image = UIImage(named: item.DisplayedPlanetImage ?? "")
        ivPlanet.superview?.isHidden = !item.isPlanetVisible

        lblVehicleName.text = item.DisplayedVehicleName
        lblVehicleSpeed.text = item.DisplayedVehicleDistance
        ivVehicle.image = UIImage(named: item.DisplayedVehicleImage ?? "")
        ivVehicle.superview?.isHidden = !item.isVehicleVisible

        //btnSelectVehicle.isHidden = !item.isVehicleSelectionEnable
        btnSelectVehicle.superview?.superview?.isHidden = !item.isVehicleSelectionEnable
        self.buttonTarget = target
        self.btnSelectVehicle.tag = item.ItemTag
        self.btnSelectPlanet.tag = item.ItemTag
        self.buttonVehicleSelector = buttonVehicleSelector // #selector(selectVehicle(_:))
        self.buttonPlanetSelector = buttonPlanetSelector //#selector(selectPlanet(_:))


        btnSelectVehicle.setTitle(item.vehicleName, for: .normal)
        btnSelectPlanet.setTitle(item.planetName, for: .normal)
        btnSelectVehicle.isEnabled = item.isVehicleSelectionEnable

        if let selector = buttonPlanetSelector {
            btnSelectPlanet.addTarget(buttonTarget, action: selector, for: .touchUpInside)
        }

        if let selector = buttonVehicleSelector {
            btnSelectVehicle.addTarget(buttonTarget, action: selector, for: .touchUpInside)
        }
    }
}
