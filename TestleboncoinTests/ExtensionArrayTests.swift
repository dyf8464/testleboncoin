//
//  ExtensionArrayTests.swift
//  testleboncoinTests
//
//  Created by zhizi yuan on 20/07/2021.
//

import XCTest
@testable import testleboncoin
class ExtensionArrayTests: XCTestCase {

    var sut: [Int]! = nil
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        sut = [1, 0, 2, 10, 5]
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        try super.tearDownWithError()
    }

     func testIsAscending() {
        //Given
        sut.sort(by: <)
        //When
        let result = sut.isAscending()
        //Then
        XCTAssertTrue(result)
    }

    func testIsDescending() {
       //Given
       sut.sort(by: >)
       //When
        let result = sut.isDescending()
       //Then
       XCTAssertTrue(result)
   }
}
