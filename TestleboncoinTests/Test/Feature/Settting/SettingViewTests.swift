//
//  SettingView.swift
//  testleboncoinTests
//
//  Created by zhizi yuan on 22/07/2021.
//

import XCTest
@testable import testleboncoin
class SettingViewTests: XCTestCase {
    var sut: SettingView!
    let window: UIWindow = UIWindow()
    let title = "testTitle"
    let modelUrl = URL(fileURLWithPath: Bundle.main.path(forResource: Constants.testCategoryFileName, ofType: "json")!)
    var categoryList: [CategoryModel]!
    var cellModelSelected: CategoryModel!
    var completion: ((SettingCellModel, Int) -> Void)!
    var settingViewModel: SettingViewModel!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = SettingView(parentWindow: window, settingViewFrame: CGRect(x: 0, y: 0, width: 0, height: 0))
        categoryList =  try JSONDecoder().decode([CategoryModel].self, from: Data(contentsOf: modelUrl))
        cellModelSelected = categoryList[0]
        completion = {_, _ in
        }
        settingViewModel = SettingViewModel.init(cellModelList: categoryList, title: title, cellModelSelected: cellModelSelected, completion: completion)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        categoryList = nil
        cellModelSelected = nil
        completion = nil
        settingViewModel = nil
    }

    func test_showSettings_return_success() throws {

        //Given
        let settingViewModel: SettingViewModel = self.settingViewModel

        //When
        sut.showSettings(viewModel: settingViewModel)

        //Then
        XCTAssertEqual(self.sut.titleLabel.text, title)
        XCTAssertNotNil(self.sut.tableView.delegate)
        XCTAssertNotNil(self.sut.tableView.dataSource)
        XCTAssertNotNil(settingViewModel.settingViewModelDelegate)
        XCTAssertNotNil(self.sut.viewModel)
        XCTAssertEqual(self.sut.alpha, 1)
    }

    func test_handleDismissSettingView() throws {

        //Given
        sut.showSettings(viewModel: settingViewModel)

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            //When
            self.sut.handleDismissSettingView()
            //Then
            XCTAssertNil(self.sut.superview)
            XCTAssertNil(self.sut.viewModel)
            XCTAssertEqual(self.sut.alpha, 0)
        }
    }


    func test_settingItemSelectFinished() throws {

        //Given
        sut.showSettings(viewModel: settingViewModel)

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            //When
            self.sut.handleDismissSettingView()
            //Then
            XCTAssertNil(self.sut.superview)
            XCTAssertNil(self.sut.viewModel)
            XCTAssertEqual(self.sut.alpha, 0)
        }
    }

}
