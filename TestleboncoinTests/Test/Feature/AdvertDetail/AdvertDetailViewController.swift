//
//  AdvertDetailViewController.swift
//  testleboncoinTests
//
//  Created by zhizi yuan on 23/07/2021.
//

import XCTest
@testable import testleboncoin
class TestAdvertDetailViewController: XCTestCase {

    let url = URL(fileURLWithPath: Bundle.main.path(forResource: Constants.testAdvertItemFileName, ofType: "json")!)
    var sut: AdvertDetailViewController!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        let advertItemModel = try JSONDecoder().decode(AdvertItemModel.self, from: Data(contentsOf: url))
        sut = AdvertDetailViewController()
        sut.viewModel = advertItemModel
        _  = sut.view
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_properties() throws {
        XCTAssertEqual(sut.titleLabel.text, "test Title")
        XCTAssertEqual(sut.priceLabel.text, "Prix : 140.00 €")
        XCTAssertEqual(sut.descriptionLabel.text, "test Description")
        XCTAssertEqual(sut.dateLabel.text, "05-11-2019 à 16:56")
        XCTAssertEqual(sut.urgentLabel.text, "urgent")
        XCTAssertTrue(sut.urgentLabel.isHidden)
    }

}
