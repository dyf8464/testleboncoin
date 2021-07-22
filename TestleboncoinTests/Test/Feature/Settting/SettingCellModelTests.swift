//
//  SettingCellModelTests.swift
//  testleboncoinTests
//
//  Created by zhizi yuan on 22/07/2021.
//

import XCTest
@testable import testleboncoin
class SettingCellModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_CategoryModel_settingCellName() throws {
        //Given
        let modelUrl = URL(fileURLWithPath: Bundle.main.path(forResource: Constants.testCategoryFileName, ofType: "json")!)

        let categoryList =  try JSONDecoder().decode([CategoryModel].self, from: Data(contentsOf: modelUrl))

        //When
        let reslut = categoryList[0].settingCellName

        //Then
        XCTAssertEqual(reslut, "Véhicule")
    }

    func test_SortByDate_settingCellName_ascending() throws {
        //Given
        let sortByDate = KEnum.SortByDate.ascending

        //When
        let reslut = sortByDate.settingCellName

        //Then
        XCTAssertEqual(reslut, "Plus anciennes")
    }

    func test_SortByDate_settingCellName_descending() throws {
        //Given
        let sortByDate = KEnum.SortByDate.descending

        //When
        let reslut = sortByDate.settingCellName

        //Then
        XCTAssertEqual(reslut, "Plus récentes")
    }
}
