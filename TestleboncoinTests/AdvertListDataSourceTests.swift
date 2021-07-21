//
//  AdvertListDataSourceTest.swift
//  testleboncoinTests
//
//  Created by zhizi yuan on 21/07/2021.
//

import XCTest
@testable import testleboncoin
class AdvertListDataSourceTests: XCTestCase {

    class MockAdvertListDataSource: AdvertListDataSource {
        var cellListVM: [AdvertItemViewModel]?
    }
    var sut: MockAdvertListDataSource!
    let url = URL(fileURLWithPath: Bundle.main.path(forResource: Constants.testAdvertListFileName, ofType: "json")!)
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = MockAdvertListDataSource()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
    }

    func testCountCellReturnNoZero() throws {
        //Given
        let list = try JSONDecoder().decode([AdvertItemModel].self, from: Data(contentsOf: url))
        sut.cellListVM = list

        //When
        let count = sut.countCell()
        //Then
        XCTAssertEqual(count, 300)
    }

    func testCountCellReturnZero() throws {
        //Given
        sut.cellListVM = nil

        //When
        let count = sut.countCell()
        //Then
        XCTAssertEqual(count, 0)
    }

    func testAdvertItemViewModelIndexPathReturnNoEmpty() throws {
        //Given
        let list = try JSONDecoder().decode([AdvertItemModel].self, from: Data(contentsOf: url))
        sut.cellListVM = list

        //When
        let advertItemViewModel = sut.advertItemViewModel(indexPath: IndexPath(row: 0, section: 0))

        //Then
        XCTAssertEqual(advertItemViewModel.titleVM, "Statue homme noir assis en plâtre polychrome")
    }

    func testAdvertItemViewModelIndexPathReturnNewAdvertItemModel() throws {
        //Given
        sut.cellListVM = nil

        //When
        let advertItemModel = sut.advertItemViewModel(indexPath: IndexPath(row: 0, section: 0)) as? AdvertItemModel

        //Then
        XCTAssertEqual(advertItemModel!, AdvertItemModel())
    }

}
