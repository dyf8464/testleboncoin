//
//  AdvertListViewModelTests.swift
//  testleboncoinTests
//
//  Created by zhizi yuan on 18/07/2021.
//

import XCTest
@testable import testleboncoin
class AdvertListViewModelTests: XCTestCase {

    var sut: AdvertListViewModel!

    //mock data
    let dataAdvertList = Data.loadFileFromLocalPath(Bundle.main.path(forResource: Constants.testAdvertListFileName, ofType: "json"))!
    let dataErrorAdvertList = Data.loadFileFromLocalPath(Bundle.main.path(forResource: Constants.testAdvertListErrorFileName, ofType: "json"))!
    let dataCategories = Data.loadFileFromLocalPath(Bundle.main.path(forResource: Constants.testCategoryFileName, ofType: "json"))!
    let dataErrorCategories = Data.loadFileFromLocalPath(Bundle.main.path(forResource: Constants.testCategoryErrorFileName, ofType: "json"))!
    var session: TestSession!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = AdvertListViewModel()

        //mock apiProvider
        session = TestSession()
        let apiProvider = APIProvider(session: session)
        sut.apiProvider = apiProvider

    }

    override func tearDownWithError() throws {
        sut = nil
        session = nil
        try super.tearDownWithError()
    }

    func testFetchDataReturnSuccess() {
        //Given
        let expectation = XCTestExpectation()
        session.registerTestResponse(Constants.urlAdvertCategory, data: dataCategories)
        session.registerTestResponse(Constants.urlAdvertList, data: dataAdvertList)
        //When
        sut.fetchData(success: {
            //Then
            //Test advertList, categories
            XCTAssertEqual(self.sut.advertList!.count, 300)
            XCTAssertEqual(self.sut.categories!.count, 11)
            //Test CategoryNameDelegate
            XCTAssertEqual(self.sut.nameCategory(idCategory: 1), "Véhicule")
            expectation.fulfill()
        },
        alertMessage: {
            //Then
            print("\($0)")
            XCTAssertTrue(false)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 10.0)
    }

    func testFetchDataWithBadFormatJson() {
        //Given
        let expectation = XCTestExpectation()
        session.registerTestResponse(Constants.urlAdvertCategory, data: dataErrorCategories)
        session.registerTestResponse(Constants.urlAdvertList, data: dataErrorAdvertList)
        //When
        sut.fetchData(success: {
            //Then
            XCTAssertTrue(false)
            expectation.fulfill()
        },
        alertMessage: {
            //Then
            XCTAssertEqual($0, AdvertListViewModel.jsonDecoderMessage)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 10.0)
    }

    func testFechDataReturnErrorStatusCode() {
        //Given
        let expectation = XCTestExpectation()
        session.registerTestResponse(Constants.urlAdvertCategory, data: dataCategories, statusCode: 404)
        session.registerTestResponse(Constants.urlAdvertList, data: dataAdvertList, statusCode: 404)
        //When
        sut.fetchData(success: {
            //Then
            XCTAssertTrue(false)
            expectation.fulfill()
        },
        alertMessage: {
            //Then
            XCTAssertEqual($0, AdvertListViewModel.badResponseMessage)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 10.0)
    }

    func testFechDataReturnErrorUnkown() {
        //Given
        let expectation = XCTestExpectation()
        session.registerTestResponse(Constants.urlAdvertCategory, data: dataCategories, error: TestSession.MockError())
        session.registerTestResponse(Constants.urlAdvertList, data: dataAdvertList, error: TestSession.MockError())
        //When
        sut.fetchData(success: {
            //Then
            XCTAssertTrue(false)
            expectation.fulfill()
        },
        alertMessage: {
            //Then
            XCTAssertEqual($0, AdvertListViewModel.unKnwonMessage)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 10.0)
    }

}
