//
//  SettingCellTest.swift
//  testleboncoinTests
//
//  Created by zhizi yuan on 22/07/2021.
//

import XCTest
@testable import testleboncoin
class SettingCellTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_loadModel_isSelected_true() throws {
        //Given
        let cell = SettingCell(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        let cellModel = KEnum.SortByDate.ascending

        //When
        cell.loadModel(cellModel, isSelected: true)

        //Then
        XCTAssertEqual(cell.titleLabel.text, cellModel.settingCellName)
        XCTAssertEqual(cell.selectImageView.image!.pngData(), SettingCell.imageSelected.pngData())
    }

    func test_loadModel_isSelected_false() throws {
        //Given
        let cell = SettingCell(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        let cellModel = KEnum.SortByDate.ascending

        //When
        cell.loadModel(cellModel, isSelected: false)

        //Then
        XCTAssertEqual(cell.titleLabel.text, cellModel.settingCellName)
        XCTAssertEqual(cell.selectImageView.image!.pngData(), SettingCell.imageUnselected.pngData())
    }

}
