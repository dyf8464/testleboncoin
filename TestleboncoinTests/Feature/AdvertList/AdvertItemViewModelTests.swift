//
//  AdvertItemViewModelTests.swift
//  testleboncoinTests
//
//  Created by zhizi yuan on 19/07/2021.
//

import XCTest
@testable import testleboncoin
class AdvertItemViewModelTests: XCTestCase {

    class MockCategoryNameDelegate: CategoryNameDelegate {
        var categories: [CategoryModel]?
    }

    let url = URL(fileURLWithPath: Bundle.main.path(forResource: Constants.testAdvertItemFileName, ofType: "json")!)
    var sut: AdvertItemModel!

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

    func testAdvertItemViewModel() {
        XCTAssertEqual(sut.titleVM, "test Title")
        XCTAssertEqual(sut.priceVM, "140.00 €")
        XCTAssertEqual(sut.creationDateStringVM, "05-11-2019 16:56")
        XCTAssertEqual(sut.creationDateVM, "2019-11-05T15:56:59+0000".toDate(withFormat: ConstantsUtils.dateFormatJson))
        XCTAssertEqual(sut.nameCateogryVM, "")
        XCTAssertEqual(sut.isUrgentVM, false)
        XCTAssertEqual(sut.smallImageUrl, "https://raw.githubusercontent.com/leboncoin/paperclip/master/ad-small/2c9563bbe85f12a5dcaeb2c40989182463270404.jpg")
    }

    func testAdvertItemViewModelNameCateogryVM() throws {
        let mockCategoryNameDelegate = MockCategoryNameDelegate()
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: Constants.testCategoryFileName, ofType: "json")!)
        let categories = try JSONDecoder().decode([CategoryModel].self, from: Data(contentsOf: url))
        mockCategoryNameDelegate.categories = categories
        sut.delegate = mockCategoryNameDelegate
        XCTAssertEqual(sut.nameCateogryVM, "Maison")
    }
}
