//
//  AdvertListViewControllerTests.swift
//  testleboncoinTests
//
//  Created by zhizi yuan on 23/07/2021.
//

import XCTest
@testable import testleboncoin
class AdvertListViewControllerTests: XCTestCase {

    //mock data
    var sut: AdvertListViewController!
    var advertListViewModel: AdvertListViewModel!
    let dataAdvertList = Data.loadFileFromLocalPath(Bundle.main.path(forResource: Constants.testAdvertListFileName, ofType: "json"))!
    let dataCategories = Data.loadFileFromLocalPath(Bundle.main.path(forResource: Constants.testCategoryFileName, ofType: "json"))!
    var session: TestSession!

    override func setUpWithError() throws {
        try super.setUpWithError()
        //mock AdvertListViewModel
        advertListViewModel = AdvertListViewModel()

        //mock apiProvider
        session = TestSession()
        let apiProvider = APIProvider(session: session)
        advertListViewModel.apiProvider = apiProvider

        sut = AdvertListViewController()
        sut.viewModel = advertListViewModel
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        advertListViewModel = nil
        session = nil
        sut = nil
        try super.tearDownWithError()
    }

    func test_asyncdata_success() throws {
        //Given
        let expectation = XCTestExpectation()
        session.registerTestResponse(Constants.urlAdvertCategory, data: dataCategories)
        session.registerTestResponse(Constants.urlAdvertList, data: dataAdvertList)

        //When
         _ = sut.view

        //Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(self.sut.title, "Leboncoin")
            guard let cell = self.sut.tableView(self.sut.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? AdvertCell
            else {
              XCTAssertTrue(false)
              return
            }
            XCTAssertEqual(cell.categoryLabel.text, "Mode")
            XCTAssertEqual(cell.titleLabel.text, "Ensemble fille 1 mois NEUF")
            XCTAssertEqual(cell.priceLabel.text, "5.00 €")
            XCTAssertEqual(cell.urgentLabel.isHidden, false)
            XCTAssertEqual(cell.dateLabel.text, "05-11-2019 16:56")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }
}
