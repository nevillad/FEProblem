//
//  FEDashboardViewControllerTests.swift
//  FEProblemTests
//
//  Created by Nevilkumar Lad on 06/02/22.
//

import XCTest
@testable import FEProblem

class FEDashboardViewControllerTests: XCTestCase {

    var sut: FEDashboardViewController!
    var spyInteractor: FEDashboardBusinessLogicSpy!

    func setupFEDashboardViewController() {
        sut = FEDashboardViewController.instantiateFromStoryboard()
        spyInteractor = FEDashboardBusinessLogicSpy()
        sut.interactor = spyInteractor
      //  loadview()
    }

    override func setUpWithError() throws {
        setupFEDashboardViewController()

        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testViewDidLoad() {
        XCTAssertNotNil(sut, "Should not be nill")
        //XCTAssertTrue(sut.title == "Finding Falcone", "Viewcontroller Title should be Finding Falcone")
        
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
