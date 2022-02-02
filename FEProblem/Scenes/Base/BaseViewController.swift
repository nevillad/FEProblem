//
//  BaseViewController.swift
//  FEProblem
//
//  Created by Nevilkumar Lad on 02/02/22.
//

import UIKit

class BaseViewController: UIViewController {
    /// shared instance of delegate is available to all child classes
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    /// It makes user-defauls easily available to all child classes

    var statusBarStyle: UIStatusBarStyle = .default

    //MARK: - View Controllers Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set navigation bars Font attribute for all child classes
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barStyle = self.statusBarStyle == .lightContent ? .black : .default
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.barStyle = self.statusBarStyle == .lightContent ? .black : .default
    }

    deinit {

    }

    //MARK:- Indicators
    func showIndicator(_ message: String, showProgress: Bool = false){

    }

    func updateProgressForIndicator(progress : Double) {

    }

    func hideIndicator(){

    }
}
