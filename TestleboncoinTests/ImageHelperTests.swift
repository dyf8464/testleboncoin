//
//  ImageHelperTests.swift
//  testleboncoinTests
//
//  Created by zhizi yuan on 18/07/2021.
//

import XCTest
@testable import testleboncoin
class ImageHelperTests: XCTestCase {
    let testImageData = Data.loadFileFromLocalPath(Bundle.main.path(forResource: Constants.testImageName, ofType: "jpg"))!
    var session: TestSession!

    override func setUpWithError() throws {
       try super.setUpWithError()
        //mock session
        session  = TestSession()

    }

    override func tearDownWithError() throws {
        session = nil
        try super.tearDownWithError()
    }

    func testFetchDataReturnSuccess() {
        //Given
        let expectation = XCTestExpectation()
        session.registerTestResponse(Constants.urlTestImage, data: testImageData)

        //When
        ImageHelper.fetchImage(session: session, url: Constants.urlTestImage) {
            switch $0 {
            //Then
            case .success(let data):
                XCTAssertEqual(data, self.testImageData)
                expectation.fulfill()
            case .error(_):
                XCTAssertTrue(false)
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 10.0)
    }

    func testFetchDataReturnError() {
        //Given
        let expectation = XCTestExpectation()
        session.registerTestResponse(Constants.urlTestImage, data: testImageData, error: TestSession.MockError())

        //When
        ImageHelper.fetchImage(session: session, url: Constants.urlTestImage) {
            switch $0 {
            //Then
            case .success(_):
                XCTAssertTrue(false)
                expectation.fulfill()
            case .error(_):
                XCTAssertTrue(true)
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 10.0)
    }
}
