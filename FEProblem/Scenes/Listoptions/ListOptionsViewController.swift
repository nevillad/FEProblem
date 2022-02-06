//
//  ListOptionsViewController.swift
//  FEProblem
//
//  Created by Nevilkumar Lad on 03/02/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
protocol ListOptionDelegate {
    func didSelect(_id: Int64, selectionType: SelecionType)
}

protocol ListOptionsDisplayLogic: class {
    func displayListOptionsDetails(viewModel: ListOptionsModel.ListOptionsDetails.ViewModel)
    func displayNextScene(viewModel: ListOptionsModel.NextScene.ViewModel)
    func displayLoader(type: ListOptionsLoaderType)
    func hideLoader(type: ListOptionsLoaderType)
    func displayError(type: ListOptionsErrorType)
    func displayListOptions(viewModel: ListOptionsModel.ListOptions.ViewModel)
}

class ListOptionsViewController: BaseViewController, ListOptionsDisplayLogic {
    var interactor: ListOptionsBusinessLogic?
    var router: (NSObjectProtocol & ListOptionsRoutingLogic & ListOptionsDataPassing)?

    fileprivate var displayedList: [ListOptionsModel.ListOptions.ViewModel.DisplayedList] = []

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var ivPlanet: UIImageView!
    @IBOutlet weak var lblPlanetName: UILabel!
    @IBOutlet weak var lblPlanetDistance: UILabel!
    @IBOutlet weak var vwPlanet: UIView!
    @IBOutlet weak var tvListOptions: IntrinsicTableView!

    var delegate: ListOptionDelegate?
    
    class func instantiateFromStoryboard() ->  ListOptionsViewController {

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as!  ListOptionsViewController //
    }

    // MARK: Object lifecycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: Setup

    private func setup() {
        let viewController = self
        let interactor = ListOptionsInteractor()
        let presenter = ListOptionsPresenter()
        let router = ListOptionsRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    // MARK: Routing

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }

    // MARK: View lifecycle

    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialise()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor?.initialise(showLoader: true)
    }
    // MARK: Do something

    private func initialise() {
        tvListOptions.bottomPadding = 0
        tvListOptions.estimatedRowHeight = 1000
        tvListOptions.rowHeight = UITableView.automaticDimension
        tvListOptions.register(UINib(nibName: kListOptionsTableViewCell_ID, bundle: Bundle.main), forCellReuseIdentifier: kListOptionsTableViewCell_ID)
        tvListOptions.bottomPadding = 0
        //tvListOptions.register(ListOptionsTableViewCell.self, forCellReuseIdentifier: kListOptionsTableViewCell_ID)
        tvListOptions.dataSource = self
        tvListOptions.delegate = self

        vwPlanet.layer.borderColor = secondaryLightGrey.cgColor
        vwPlanet.layer.borderWidth = 0.5
        vwPlanet.clipsToBounds = true
        //vwPlanet.layer.cornerRadius = kCornerRadius
        //vwPlanet.layer.masksToBounds = true
        //vwPlanet.layer.shadowColor = secondaryLightGrey.cgColor
        //vwPlanet.layer.shadowOpacity = 1
        //vwPlanet.layer.shadowOffset = CGSize(width: 0, height: 4)
        //vwPlanet.layer.shadowRadius = 4

        //interactor?.initialise(showLoader: false)
    }

    // MARK: Do ListOptionsDetails

    //@IBOutlet weak var nameTextField: UITextField!

    func doListOptionsDetails() {
        let request = ListOptionsModel.ListOptionsDetails.Request()
        interactor?.doListOptionsDetails(request: request)
    }

    func displayListOptions(viewModel: ListOptionsModel.ListOptions.ViewModel) {
        displayedList = viewModel.displayedList
        self.lblTitle.text = viewModel.title.uppercased()
      //  self.lblSubTitle.text = viewModel.subTitle
        self.lblPlanetName.text = viewModel.planetName
        self.lblPlanetDistance.text = viewModel.planetDistance
        self.vwPlanet.superview?.isHidden = !viewModel.isPlanetViewVisible
        self.ivPlanet.image = UIImage(named: viewModel.planetName?.lowercased() ?? "")
        debugPrint(viewModel)
    }

    func displayListOptionsDetails(viewModel: ListOptionsModel.ListOptionsDetails.ViewModel) {
        //nameTextField.text = viewModel.name
    }

    func displayNextScene(viewModel: ListOptionsModel.NextScene.ViewModel) {
        delegate?.didSelect(_id: viewModel._id, selectionType: viewModel.selectionType)
        self.dismiss(animated: true, completion: nil)
    }

    func displayLoader(type: ListOptionsLoaderType) {
        DispatchQueue.main.async {
            switch type {
            case .general: super.showIndicator("please wait...")
            }
        }
    }

    func hideLoader(type: ListOptionsLoaderType) {
        super.hideIndicator()
    }

    func displayError(type: ListOptionsErrorType) {

    }
}


// MARK: UITableView delegate and datasource
extension ListOptionsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kListOptionsTableViewCell_ID, for: indexPath) as! ListOptionsTableViewCell
        let listModel = displayedList[indexPath.row]
        cell.lblTitle.text = listModel.title
        cell.lblSubTitle.text = listModel.subTitle


        if let lImage = listModel.leftImage, !lImage.isEmpty() {
            cell.ivLeft.image = UIImage(named: lImage)
            cell.ivLeft.superview?.isHidden  = false
        }
        cell.toggleCellStyle(isSelected: listModel.isSelcted)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var listModel = displayedList[indexPath.row]
        //if (listModel.leftImage ?? "").isEmpty() {
            //let currentCell = tableView.cellForRow(at: indexPath) as? ListOptionsTableViewCell {
          //  listModel.isSelcted = !listModel.isSelcted
            // currentCell.toggleCellStyle(isSelected: listModel.isSelcted)
            // update array
            //displayedList[indexPath.row] = listModel
        //}
        interactor?.selectItem(index: indexPath.row)

    }
}