//
//  testleboncoinTests.swift
//  testleboncoinTests
//
//  Created by zhizi yuan on 15/07/2021.
//

import XCTest
@testable import testleboncoin

class TestSessionTests: XCTestCase {

    let endpoint = URL(string: "https://test.com/leboncoin/test")!
    let sampleData = "leboncoin_dengyangfan".data(using: .utf8)!
    var sut: TestSession!

    override func setUpWithError() throws {
       try super.setUpWithError()
        //mock TestSession
        sut = TestSession()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    // MARK: - Tests
    func testMockDataTaskURL() {
        //Given
        let expectation = XCTestExpectation()
        sut.registerTestResponse(endpoint, data: sampleData)
        XCTAssertNil(sut.resumedResponse(endpoint))

        //When
        sut.dataTask(with: endpoint) { (data: Data?, response: URLResponse?, error: Error?) in

            //THEN
            XCTAssertEqual(self.sampleData, data)
            XCTAssertNotNil(response)
            XCTAssertNil(error)
            XCTAssertNotNil(self.sut.resumedResponse(self.endpoint))
            expectation.fulfill()
        }.resume()
        wait(for: [expectation], timeout: 10.0)
    }

    func testMockDataTaskRequest() {
        //Given
        let expectation = XCTestExpectation()
        sut.registerTestResponse(endpoint, data: sampleData)
        XCTAssertNil(sut.resumedResponse(endpoint))

        //When
        sut.dataTask(with: URLRequest.init(url: endpoint)) { (data: Data?, response: URLResponse?, error: Error?) in

            //Then
            XCTAssertEqual(self.sampleData, data)
            XCTAssertNotNil(response)
            XCTAssertNil(error)
            XCTAssertNotNil(self.sut.resumedResponse(self.endpoint))
            expectation.fulfill()
        }.resume()
        wait(for: [expectation], timeout: 10.0)
    }

    func testDataTaskNoRegisterTestResponse() {
        //Given
        let expectation = XCTestExpectation()
        //When
        sut.dataTask(with: endpoint) { (data: Data?, response: URLResponse?, error: Error?) in

            //Then
            XCTAssertNil(data)
            XCTAssertNil(response)
            XCTAssertEqual(TestSession.MockError.Code.NoResponseRegistered.rawValue, ((error as NSError?)?.code))
            expectation.fulfill()
        }.resume()
        wait(for: [expectation], timeout: 10.0)
    }
}
