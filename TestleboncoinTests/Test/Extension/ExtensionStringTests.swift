//
//  ExtensionStringTests.swift
//  testleboncoinTests
//
//  Created by zhizi yuan on 19/07/2021.
//

import XCTest
@testable import testleboncoin
class ExtensionStringTests: XCTestCase {
    let dateString = "2019-11-05T15:56:59+0000"
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_toDate_return_noNil () {
        //Given
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = ConstantsUtils.dateFormatJson
        let dateExp = dateFormatter.date(from: dateString)
        //When
        let dateTest = dateString.toDate(withFormat: ConstantsUtils.dateFormatJson)
        //Then
        XCTAssertEqual(dateTest, dateExp)
    }

    func test_toDate_return_nil () {
        //Given
        let format = ConstantsUtils.dateFormatVM
        //When
        let dateTest = dateString.toDate(withFormat: format)
        //Then
        XCTAssertNil(dateTest)
    }

    func test_toString_with_NewFormat_return_noNil () {
        //Given
        let stringExp = "05-11-2019 16:56"
        //When
        let stringTest = dateString.toString(withFormat: ConstantsUtils.dateFormatJson, toFormat: ConstantsUtils.dateFormatVM)
        //Then
        XCTAssertEqual(stringTest, stringExp)
    }

    func test_toString_with_newFormat_return_stringEmpty () {
        //Given
        let wrongFormat = ConstantsUtils.dateFormatVM
        //When
        let stringTest = dateString.toString(withFormat: wrongFormat, toFormat: ConstantsUtils.dateFormatVM)
        //Then
        XCTAssertEqual("", stringTest)
    }
}
