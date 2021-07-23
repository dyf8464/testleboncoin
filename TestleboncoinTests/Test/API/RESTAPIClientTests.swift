//
//  RESTAPIClientTests.swift
//  testleboncoinTests
//
//  Created by zhizi yuan on 16/07/2021.
//

import XCTest
@testable import testleboncoin
class RESTAPIClientTests: XCTestCase {

    class MockAPIProvider: RESTAPIClient {

        let baseURL = "https://TestAPIProvider.com/api/"
        var testURL: URL {
            URL(string: baseURL)!
        }
        let session: URLSession = TestSession()
        func testRequestAPI(completion: @escaping (APIResult<[CategoryModel]>) -> Void) {
            self.requestAPI(with: URLRequest(url: testURL), completion: completion)
        }
    }
    var sut: MockAPIProvider!

    override func setUpWithError() throws {
       try super.setUpWithError()
        //mock MockAPIProvider
        sut = MockAPIProvider()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    // MARK: - Tests
    func test_requestAPI_return_success() {
        //Given
        let expectation = XCTestExpectation()
        let path = Bundle.main.path(forResource: Constants.testCategoryFileName, ofType: "json")
        if let sampleData = Data.loadFileFromLocalPath(path), let session = sut.session as? TestSession {
            session.registerTestResponse(sut.testURL, data: sampleData)

            //When
            sut.testRequestAPI { (result: APIResult<[CategoryModel]>) in
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
        } else {
            XCTAssertTrue(false)
        }

        wait(for: [expectation], timeout: 10.0)
    }

    func test_requestAPI_with_badFormatJSON_return_error() {
        //Given
        let expectation = XCTestExpectation()
        let path = Bundle.main.path(forResource: Constants.testCategoryErrorFileName, ofType: "json")
        if let sampleData = Data.loadFileFromLocalPath(path), let session = sut.session as? TestSession {
            session.registerTestResponse(sut.testURL, data: sampleData)

            //When
            sut.testRequestAPI { (result: APIResult<[CategoryModel]>) in
                switch result {
                case .success(_) :
                    //Then
                    XCTAssertTrue(false)
                    expectation.fulfill()
                case let .error(error):
                    //Then
                    switch error {
                    case APIError.jsonDecoder:
                        XCTAssertTrue(true)
                    default:
                        XCTAssertTrue(false)
                    }
                    expectation.fulfill()
                }
            }
        } else {
            XCTAssertTrue(false)
        }
        wait(for: [expectation], timeout: 10.0)
    }

    func test_requestAPI_return_errorStatusCode() {
        //Given
        let expectation = XCTestExpectation()
        let path = Bundle.main.path(forResource: Constants.testCategoryFileName, ofType: "json")
        if let sampleData = Data.loadFileFromLocalPath(path), let session = sut.session as? TestSession {
            session.registerTestResponse(sut.testURL, data: sampleData, statusCode: 404)
            //When
            sut.testRequestAPI { (result: APIResult<[CategoryModel]>) in
                switch result {
                case .success(_) :
                    //Then
                    XCTAssertTrue(false)
                    expectation.fulfill()
                case let .error(error):
                    //Then
                    switch error {
                    case APIError.badResponse:
                        XCTAssertTrue(true)
                    default:
                        XCTAssertTrue(false)
                    }
                    expectation.fulfill()
                }
            }
        } else {
            XCTAssertTrue(false)
        }
        wait(for: [expectation], timeout: 10.0)
    }

    func test_request_success() {
        let endPoint = APIEndPoint.advertCategory
        let request = sut.request(endPoint: endPoint)
        XCTAssertEqual(request, URLRequest(url: URL(string: sut.baseURL + APIEndPoint.advertCategory.endPointURL)!))
    }

}
