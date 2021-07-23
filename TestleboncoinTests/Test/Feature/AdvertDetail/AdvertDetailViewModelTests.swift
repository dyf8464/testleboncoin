//
//  AdvertDetailViewModelTests.swift
//  testleboncoin
//
//  Created by zhizi yuan on 23/07/2021.
//
import XCTest
@testable import testleboncoin
class AdvertDetailViewModelTests: XCTestCase {

    let url = URL(fileURLWithPath: Bundle.main.path(forResource: Constants.testAdvertItemFileName, ofType: "json")!)
    var sut: AdvertDetailViewModel!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
       try super.setUpWithError()
       sut = try JSONDecoder().decode(AdvertItemModel.self, from: Data(contentsOf: url))
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        try super.tearDownWithError()
    }

    func test_advertDetailViewModel_properties() {
        XCTAssertEqual(sut.detailTitleVM, "test Title")
        XCTAssertEqual(sut.detailPriceVM, "Prix : 140.00 €")
        XCTAssertEqual(sut.detailDescription, "test Description")
        XCTAssertEqual(sut.detailCreationDateStringVM, "05-11-2019 à 16:56")
        XCTAssertEqual(sut.detailImageUrl, "https://raw.githubusercontent.com/leboncoin/paperclip/master/ad-thumb/2c95.jpg")
        XCTAssertEqual(sut.detailIsUrgentVM, false)
        XCTAssertEqual(sut.detailNameCategory, "")
    }
}
