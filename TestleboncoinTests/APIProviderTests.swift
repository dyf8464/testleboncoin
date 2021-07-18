//
//  APIProviderTests.swift
//  testleboncoinTests
//
//  Created by zhizi yuan on 16/07/2021.
//

import XCTest
@testable import testleboncoin
class APIProviderTests: XCTestCase {

    var sut: APIProvider!

    override func setUp() {
        super.setUp()
        let session: URLSession = TestSession()
        sut = APIProvider(session: session)
    }
    override func tearDown() {
        super.tearDown()
        sut = nil
    }

    // MARK: - Tests
    func testFetchCategoriesReturnSuccess() {
        //Given
        let expectation = XCTestExpectation()
        let requestExpect = self.requestExpectAdvertCategory()
        let path = Bundle.main.path(forResource: Constants.testCategoryFileName, ofType: "json")
        if let sampleData = Data.loadFileFromLocalPath(path), let session = sut.session as? TestSession {
            session.registerTestResponse(sut.request(endPoint: APIEndPoint.advertCategory).url!, data: sampleData)
            //When
            let requestTest = sut.fetchCategories { (result: APIResult<[CategoryModel]>) in
                switch result {
                case let .success(categories) :
                    //Then
                    XCTAssertEqual(categories.count, 11)
                    XCTAssertEqual(categories[0].id, 1)
                    XCTAssertEqual(categories[0].name, "Véhicule")
                    expectation.fulfill()
                case .error(_):
                    //Then
                    XCTAssertTrue(false)
                    expectation.fulfill()
                }
            }
            //vérifcation Request
            XCTAssertEqual(requestTest, requestExpect)
        } else {
            XCTAssertTrue(false)
        }
        wait(for: [expectation], timeout: 10.0)
    }

    func testFetchAdvertListReturnSuccess() {
        //Given
        let expectation = XCTestExpectation()
        let requestExpect = self.requestExpectAdvertList()
        let path = Bundle.main.path(forResource: Constants.testAdvertListFileName, ofType: "json")
        if let sampleData = Data.loadFileFromLocalPath(path), let session = sut.session as? TestSession {
            session.registerTestResponse(sut.request(endPoint: APIEndPoint.advertList).url!, data: sampleData)
            //When
            let requestTest = sut.fetchAdvertList { (result: APIResult<[AdvertItemModel]>) in
                switch result {
                case let .success(advertItems) :
                    //Then
                    XCTAssertEqual(advertItems.count, 300)
                    XCTAssertEqual(advertItems[0].id, 1461267313)
                    XCTAssertEqual(advertItems[0].categoryId, 4)
                    XCTAssertEqual(advertItems[0].title, "Statue homme noir assis en plâtre polychrome")
                    XCTAssertEqual(advertItems[0].price, 140.00)
                    XCTAssertNotNil(advertItems[0].description)
                    XCTAssertNotNil(advertItems[0].imagesUrl.small)
                    XCTAssertNotNil(advertItems[0].imagesUrl.thumb)
                    XCTAssertEqual(advertItems[0].creationDate, "2019-11-05T15:56:59+0000")
                    XCTAssertEqual(advertItems[0].isUrgent, false)
                    expectation.fulfill()
                case .error(_):
                    //Then
                    XCTAssertTrue(false)
                    expectation.fulfill()
                }
            }
            //vérifcation Request
            XCTAssertEqual(requestTest, requestExpect)
        } else {
            XCTAssertTrue(false)
        }
        wait(for: [expectation], timeout: 10.0)
    }

    func testFetchAdvertListWithBadFormatJson() {
        //Given
        let expectation = XCTestExpectation()
        let path = Bundle.main.path(forResource: Constants.testAdvertListErrorFileName, ofType: "json")
        if let sampleData = Data.loadFileFromLocalPath(path), let session = sut.session as? TestSession {
            session.registerTestResponse(sut.request(endPoint: APIEndPoint.advertList).url!, data: sampleData)
            //When
             sut.fetchAdvertList { (result: APIResult<[AdvertItemModel]>) in
                switch result {
                case .success(_) :
                    //Then
                    XCTAssertTrue(false)
                    expectation.fulfill()
                case let .error(error):
                    //Then
                    expectation.fulfill()
                    switch error {
                    case APIError.jsonDecoder:
                        XCTAssertTrue(true)
                    default:
                        XCTAssertTrue(false)
                    }
                }
            }
        } else {
            XCTAssertTrue(false)
        }
        wait(for: [expectation], timeout: 10.0)
    }

    func testFetchAdvertListReturnErrorStatusCode() {
        //Given
        let expectation = XCTestExpectation()
        let path = Bundle.main.path(forResource: Constants.testAdvertListFileName, ofType: "json")
        if let sampleData = Data.loadFileFromLocalPath(path), let session = sut.session as? TestSession {
            session.registerTestResponse(sut.request(endPoint: APIEndPoint.advertList).url!, data: sampleData, statusCode: 404)
            //When
             sut.fetchAdvertList { (result: APIResult<[AdvertItemModel]>) in
                switch result {
                case .success(_) :
                    //Then
                    XCTAssertTrue(false)
                    expectation.fulfill()
                case let .error(error):
                    //Then
                    expectation.fulfill()
                    switch error {
                    case APIError.badResponse:
                        XCTAssertTrue(true)
                    default:
                        XCTAssertTrue(false)
                    }
                }
            }
        } else {
            XCTAssertTrue(false)
        }
        wait(for: [expectation], timeout: 10.0)
    }

    // MARK: - Methods Private
    private func requestExpectAdvertList() -> URLRequest {
        var requestExpect = URLRequest.init(url: Constants.urlAdvertList)
        requestExpect.httpMethod = "GET"
        return requestExpect
    }

    private func requestExpectAdvertCategory() -> URLRequest {
        var requestExpect = URLRequest.init(url: Constants.urlAdvertCategory)
        requestExpect.httpMethod = "GET"
        return requestExpect
    }

}
