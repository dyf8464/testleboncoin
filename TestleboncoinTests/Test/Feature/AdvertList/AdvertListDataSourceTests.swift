//
//  AdvertListDataSourceTest.swift
//  testleboncoinTests
//
//  Created by zhizi yuan on 21/07/2021.
//

import XCTest
@testable import testleboncoin
class AdvertListDataSourceTests: XCTestCase {

    class MockAdvertItemViewModel: AdvertItemViewModel {
        var titleVM: String = ""

        var nameCateogryVM: String = ""

        var priceVM: String = ""

        var creationDateVM: Date = Date()

        var creationDateStringVM: String = ""

        var isUrgentVM: Bool = false

        var smallImageUrl: String?
    }

    class MockAdvertDetailDataSource: AdvertListDataSource {
        var cellListVM: [AdvertItemViewModel] = [MockAdvertItemViewModel]()
    }

    class MockAdvertListDataSource: AdvertListDataSource {
        var cellListVM: [AdvertItemViewModel] = [AdvertItemViewModel]()
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

    func test_countCell_return_noZero() throws {
        //Given
        let list = try JSONDecoder().decode([AdvertItemModel].self, from: Data(contentsOf: url))
        sut.cellListVM = list

        //When
        let count = sut.countCell()
        //Then
        XCTAssertEqual(count, 300)
    }

    func test_countCell_return_Zero() throws {
        //Given
        sut.cellListVM = [AdvertItemViewModel]()

        //When
        let count = sut.countCell()
        //Then
        XCTAssertEqual(count, 0)
    }

    //found AdvertItemViewModel by IndexPath
    func test_advertItemViewModelIndexPath_return_correctly() throws {
        //Given
        let list = try JSONDecoder().decode([AdvertItemModel].self, from: Data(contentsOf: url))
        sut.cellListVM = list

        //When
        let advertItemViewModel = sut.advertItemViewModel(indexPath: IndexPath(row: 0, section: 0))

        //Then
        XCTAssertEqual(advertItemViewModel.titleVM, "Statue homme noir assis en plâtre polychrome")
    }

    //return new AdvertItemModel() when indexPath.row >= cellListVM.count
    func test_advertItemViewModelIndexPath_indexOutOfRange_Return_NewAdvertItemModel() throws {
        //Given
        let list = try JSONDecoder().decode([AdvertItemModel].self, from: Data(contentsOf: url))
        sut.cellListVM = list

        //When
        let advertItemModel = sut.advertItemViewModel(indexPath: IndexPath(row: 400, section: 0)) as? AdvertItemModel

        //Then
        XCTAssertEqual(advertItemModel!, AdvertItemModel())
    }

    func test_createAdvertDetailViewController_return_correctly() throws {
        //Given
        let list = try JSONDecoder().decode([AdvertItemModel].self, from: Data(contentsOf: url))
        sut.cellListVM = list

        //When
        let viewController = sut.createAdvertDetailViewController(indexPath: IndexPath(row: 0, section: 0))

        //Then
        guard let viewModel = viewController.viewModel as? AdvertItemModel else {
             XCTAssertTrue(false)
             return
        }
        XCTAssertEqual(viewModel, list[0])
    }

    func test_createAdvertDetailViewController_return_viewController_viewModel_nil() throws {
        //Given
        let sut = MockAdvertDetailDataSource()
        sut.cellListVM = [MockAdvertItemViewModel()]

        //When
        let viewController = sut.createAdvertDetailViewController(indexPath: IndexPath(row: 0, section: 0))

        //Then

        XCTAssertNil(viewController.viewModel)
    }

}
