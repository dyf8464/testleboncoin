//
//  SettingViewModelTests.swift
//  testleboncoinTests
//
//  Created by zhizi yuan on 22/07/2021.
//

import XCTest
@testable import testleboncoin
class SettingViewModelTests: XCTestCase {
    let title = "testTitle"
    let modelUrl = URL(fileURLWithPath: Bundle.main.path(forResource: Constants.testCategoryFileName, ofType: "json")!)
    var sut: SettingViewModel!
    var categoryList: [CategoryModel]!
    var tableView: UITableView!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        categoryList =  try JSONDecoder().decode([CategoryModel].self, from: Data(contentsOf: modelUrl))
        tableView = UITableView(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        categoryList = nil
        tableView = nil
    }

    func test_init() throws {
        //Given
        let categoryList = self.categoryList!
        let title = self.title
        let cellModelSelected = self.categoryList[0]
        let completion: (SettingCellModel, Int) -> Void = {_, _ in
        }
        //When
        sut = SettingViewModel.init(cellModelList: categoryList, title: title, cellModelSelected: cellModelSelected, completion: completion)

        //Then
        XCTAssertNotNil(sut.selectedCompletion)
        XCTAssertEqual(sut.title, title)
    }

    func test_tableView_numberOfRowsInSection_return_correctly() {
        //Given
        let categoryList = self.categoryList!
        let title = self.title
        let cellModelSelected = self.categoryList[0]
        let completion: (SettingCellModel, Int) -> Void = {_, _ in
        }
        sut = SettingViewModel.init(cellModelList: categoryList, title: title, cellModelSelected: cellModelSelected, completion: completion)
        //When
        let result = sut.tableView(tableView, numberOfRowsInSection: 0)

        //Then
        XCTAssertEqual(result, 11)
    }

    func test_tableview_cellForRowAt_indexPath_return_correctly() {
        //Given
        let categoryList = self.categoryList!
        let title = self.title
        let cellModelSelected = self.categoryList[0]
        let completion: (SettingCellModel, Int) -> Void = {_, _ in
        }
        tableView.register(SettingCell.self, forCellReuseIdentifier: SettingView.settingCellId)
        sut = SettingViewModel.init(cellModelList: categoryList, title: title, cellModelSelected: cellModelSelected, completion: completion)
        //When
        let result = sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0))

        //Then
        if let settingCell = result as? SettingCell {
            XCTAssertTrue(true)
            settingCell.titleLabel.text = "Véhicule"
        } else {
            XCTAssertTrue(false)
        }
    }

    func test_tableview_cellForRowAt_indexPath_wrongCellIdentifier_return_UITableViewCell() throws {
        //Given
        let categoryList = self.categoryList!
        let title = self.title
        let cellModelSelected = self.categoryList[0]
        let completion: (SettingCellModel, Int) -> Void = {_, _ in
        }
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: SettingView.settingCellId)
        sut = SettingViewModel.init(cellModelList: categoryList, title: title, cellModelSelected: cellModelSelected, completion: completion)
        //When
        let result = sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0))

        //Then
        if let _ = result as? SettingCell {
            XCTAssertTrue(false)
        } else {
            XCTAssertTrue(true)
        }
    }

    func test_tableview_cellForRowAt_indexPath_outOfRange_return_UITableViewCell() throws {
        //Given
        let categoryList = self.categoryList!
        let title = self.title
        let cellModelSelected = self.categoryList[0]
        let completion: (SettingCellModel, Int) -> Void = {_, _ in
        }
        tableView.register(SettingCell.self, forCellReuseIdentifier: SettingView.settingCellId)
        sut = SettingViewModel.init(cellModelList: categoryList, title: title, cellModelSelected: cellModelSelected, completion: completion)
        //When
        let result = sut.tableView(tableView, cellForRowAt: IndexPath(row: 100, section: 0))

        //Then
        if let _ = result as? SettingCell {
            XCTAssertTrue(false)
        } else {
            XCTAssertTrue(true)
        }
    }

    func test_tableview_didSelectRowAt_indexPath_success() throws {
        //Given
        let categoryList = self.categoryList!
        let title = self.title
        let cellModelSelected = self.categoryList[0]
        var mockSettingCellModel: SettingCellModel! = nil
        var mockIndex = -1
        let completion: (SettingCellModel, Int) -> Void = {
            mockSettingCellModel = $0
            mockIndex = $1
        }
        tableView.register(SettingCell.self, forCellReuseIdentifier: SettingView.settingCellId)
        sut = SettingViewModel.init(cellModelList: categoryList, title: title, cellModelSelected: cellModelSelected, completion: completion)
        //When
         sut.tableView(tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
        //Then
        XCTAssertEqual(sut.nameSelecting, "Véhicule")
        XCTAssertNil(sut.cellModelSelected)
        XCTAssertNotNil(mockSettingCellModel)
        XCTAssertTrue(mockIndex != -1)
    }

    func test_tableview_didSelectRowAt_indexPath_outOfRange() throws {
        //Given
        let categoryList = self.categoryList!
        let title = self.title
        let cellModelSelected = self.categoryList[0]
        let completion: (SettingCellModel, Int) -> Void = {_, _ in

        }
        tableView.register(SettingCell.self, forCellReuseIdentifier: SettingView.settingCellId)
        sut = SettingViewModel.init(cellModelList: categoryList, title: title, cellModelSelected: cellModelSelected, completion: completion)
        //When
         sut.tableView(tableView, didSelectRowAt: IndexPath(row: 100, section: 0))
        //Then
        XCTAssertNil(sut.nameSelecting)
    }
}
