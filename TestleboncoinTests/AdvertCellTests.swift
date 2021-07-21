//
//  AdvertCellTests.swift
//  testleboncoinTests
//
//  Created by zhizi yuan on 21/07/2021.
//

import XCTest
@testable import testleboncoin
class AdvertCellTests: XCTestCase {

    var sut: AdvertCell!
    let modelUrl = URL(fileURLWithPath: Bundle.main.path(forResource: Constants.testAdvertItemFileName, ofType: "json")!)
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = AdvertCell()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLoadViewModel() throws {
        //Given
        let expectation = XCTestExpectation()
        let testImageData = Data.loadFileFromLocalPath(Bundle.main.path(forResource: Constants.testImageName, ofType: "jpg"))!
        let session: TestSession = TestSession()
        session.registerTestResponse(Constants.urlTestImage, data: testImageData)
        let advertItemModel =  try JSONDecoder().decode(AdvertItemModel.self, from: Data(contentsOf: modelUrl))
        //When
        sut.loadViewModel(viewModel: advertItemModel, session: session)
        //Then
        XCTAssertEqual(sut.categoryLabel.text, "")
        XCTAssertEqual(sut.titleLabel.text, "test Title")
        XCTAssertEqual(sut.priceLabel.text, "140.00 €")
        XCTAssertEqual(sut.urgentLabel.isHidden, true)
        XCTAssertEqual(sut.dateLabel.text, "05-11-2019 16:56")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertNotNil(self.sut.advertImageView.image)
            XCTAssertEqual(self.sut.advertImageView.image!.pngData(), UIImage(data: testImageData)!.pngData())
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }

}
