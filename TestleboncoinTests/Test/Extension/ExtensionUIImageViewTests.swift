//
//  UIImageTests.swift
//  testleboncoinTests
//
//  Created by zhizi yuan on 18/07/2021.
//

import XCTest
@testable import testleboncoin
class ExtensionUIImageViewTests: XCTestCase {
    let testImageData = Data.loadFileFromLocalPath(Bundle.main.path(forResource: Constants.testImageName, ofType: "jpg"))!
    let testDefaultImage = UIImage(data: Data.loadFileFromLocalPath(Bundle.main.path(forResource: Constants.testDefaultImageName, ofType: "jpg"))!)
    var session: TestSession!
    var imageView: UIImageView!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        ImageHelper.imageCache.removeAllObjects()
        session = TestSession()
        imageView = UIImageView()

    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        session = nil
        imageView = nil
        try super.tearDownWithError()
    }

    func testFetchDataReturnSuccess() {
        //Given
        let expectation = XCTestExpectation()
        session.registerTestResponse(Constants.urlTestImage, data: testImageData)

        //When
        imageView.asyncUrlString(Constants.urlTestImage.absoluteString, imageDefault: nil, session: session)

        //Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertNotNil(self.imageView.image)
            XCTAssertEqual(self.imageView.image!.pngData(), UIImage(data: self.testImageData)!.pngData())
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)
    }

    func testFetchDataWithUrlNil() {
        //Given
        let expectation = XCTestExpectation()

        //When
        imageView.asyncUrlString(nil, imageDefault: testDefaultImage)

        //Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertNotNil(self.imageView.image)
            XCTAssertEqual(self.imageView.image!.pngData(), self.testDefaultImage!.pngData())
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)
    }

    func testFetchDataWithUrlNoValidate() {
        //Given
        let expectation = XCTestExpectation()

        //When
        imageView.asyncUrlString("", imageDefault: testDefaultImage)

        //Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertNotNil(self.imageView.image)
            XCTAssertEqual(self.imageView.image!.pngData(), self.testDefaultImage!.pngData())
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)
    }

    func testFetchDataReturnError() {
        //Given
        let expectation = XCTestExpectation()
        session.registerTestResponse(Constants.urlTestImage, data: testImageData, error: TestSession.MockError())
        //When
        imageView.asyncUrlString(Constants.urlTestImage.absoluteString, imageDefault: testDefaultImage, session: session)

        //Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertNotNil(self.imageView.image)
            XCTAssertEqual(self.imageView.image!.pngData(), self.testDefaultImage!.pngData())
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)
    }

    func testFetchDataFromCache() {
        //Given
        let expectation = XCTestExpectation()
        session.registerTestResponse(Constants.urlTestImage, data: testImageData)

        // appeler "asynUrlString" pour sauvgarder image dans le cache
        imageView.asyncUrlString(Constants.urlTestImage.absoluteString, imageDefault: nil, session: session)

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.imageView.image = nil
            //When
            // appeler "asynUrlString" pour récupérer l'image via le cache
            self.imageView.asyncUrlString(Constants.urlTestImage.absoluteString, imageDefault: nil)

            //Then
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                XCTAssertNotNil(self.imageView.image)
                XCTAssertEqual(self.imageView.image!.pngData(), UIImage(data: self.testImageData)!.pngData())
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }

}
