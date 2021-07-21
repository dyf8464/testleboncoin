//
//  AdvertListViewModelTests.swift
//  testleboncoinTests
//
//  Created by zhizi yuan on 18/07/2021.
//

import XCTest
@testable import testleboncoin
class AdvertListViewModelTests: XCTestCase {

    var sut: AdvertListViewModel!

    //mock data
    let dataAdvertList = Data.loadFileFromLocalPath(Bundle.main.path(forResource: Constants.testAdvertListFileName, ofType: "json"))!
    let dataErrorAdvertList = Data.loadFileFromLocalPath(Bundle.main.path(forResource: Constants.testAdvertListErrorFileName, ofType: "json"))!
    let dataCategories = Data.loadFileFromLocalPath(Bundle.main.path(forResource: Constants.testCategoryFileName, ofType: "json"))!
    let dataErrorCategories = Data.loadFileFromLocalPath(Bundle.main.path(forResource: Constants.testCategoryErrorFileName, ofType: "json"))!
    var session: TestSession!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = AdvertListViewModel()

        //mock apiProvider
        session = TestSession()
        let apiProvider = APIProvider(session: session)
        sut.apiProvider = apiProvider

    }

    override func tearDownWithError() throws {
        sut = nil
        session = nil
        try super.tearDownWithError()
    }

    // MARK: - Tests API
    func testFetchDataReturnSuccess() {
        //Given
        let expectation = XCTestExpectation()
        session.registerTestResponse(Constants.urlAdvertCategory, data: dataCategories)
        session.registerTestResponse(Constants.urlAdvertList, data: dataAdvertList)
        //When
        sut.fetchData(success: {
            //Then
            //Test advertList, categories, advertListVM
            XCTAssertEqual(self.sut.advertList!.count, 300)
            XCTAssertEqual(self.sut.advertListVM!.count, 300)
            XCTAssertEqual(self.sut.categories!.count, 12)

            //Test sorted by date
            XCTAssertTrue(self.advertListVMIsSortedByUrgent(list: self.sut.advertListVM!))

            //Test insert last categorie in array
            XCTAssertEqual(self.sut.categories!.last?.id, -1)

            //Test advertItem.delegate is not nil
            for advertItem in self.sut.advertList! {
                XCTAssertNotNil(advertItem.delegate)
            }
            expectation.fulfill()
        },
        alertMessage: {
            //Then
            print("\($0)")
            XCTAssertTrue(false)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 10.0)
    }

    func testFetchDataWithBadFormatJson() {
        //Given
        let expectation = XCTestExpectation()
        session.registerTestResponse(Constants.urlAdvertCategory, data: dataErrorCategories)
        session.registerTestResponse(Constants.urlAdvertList, data: dataErrorAdvertList)
        //When
        sut.fetchData(success: {
            //Then
            XCTAssertTrue(false)
            expectation.fulfill()
        },
        alertMessage: {
            //Then
            XCTAssertEqual($0, AdvertListViewModel.jsonDecoderMessage)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 10.0)
    }

    func testFechDataReturnErrorStatusCode() {
        //Given
        let expectation = XCTestExpectation()
        session.registerTestResponse(Constants.urlAdvertCategory, data: dataCategories, statusCode: 404)
        session.registerTestResponse(Constants.urlAdvertList, data: dataAdvertList, statusCode: 404)
        //When
        sut.fetchData(success: {
            //Then
            XCTAssertTrue(false)
            expectation.fulfill()
        },
        alertMessage: {
            //Then
            XCTAssertEqual($0, AdvertListViewModel.badResponseMessage)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 10.0)
    }

    func testFechDataReturnErrorUnkown() {
        //Given
        let expectation = XCTestExpectation()
        session.registerTestResponse(Constants.urlAdvertCategory, data: dataCategories, error: TestSession.MockError())
        session.registerTestResponse(Constants.urlAdvertList, data: dataAdvertList, error: TestSession.MockError())
        //When
        sut.fetchData(success: {
            //Then
            XCTAssertTrue(false)
            expectation.fulfill()
        },
        alertMessage: {
            //Then
            XCTAssertEqual($0, AdvertListViewModel.unKnwonMessage)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 10.0)
    }

    // MARK: - Tests Sort, Filter
    func testSortByDateWithAscending() {
        //Given
        let expectation = XCTestExpectation()
        session.registerTestResponse(Constants.urlAdvertCategory, data: dataCategories)
        session.registerTestResponse(Constants.urlAdvertList, data: dataAdvertList)
        sut.fetchData(success: {
            //When
            self.sut.sortByDate(sortDate: .ascending) {
                //Then
                XCTAssertTrue(self.advertListVMIsSortedByUrgent(list: self.sut.advertListVM!))
                XCTAssertTrue(self.advertListVMIsSortedByDate(list: self.sut.advertListVM!, sortType: .ascending))
                expectation.fulfill()
            }

        },
        alertMessage: {
            print("\($0)")
            XCTAssertTrue(false)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 10.0)
    }

    func testSortByDateWithDescending() {
        //Given
        let expectation = XCTestExpectation()
        session.registerTestResponse(Constants.urlAdvertCategory, data: dataCategories)
        session.registerTestResponse(Constants.urlAdvertList, data: dataAdvertList)
        sut.fetchData(success: {
            //When
            self.sut.sortByDate(sortDate: .descending) {
                //Then
                XCTAssertTrue(self.advertListVMIsSortedByUrgent(list: self.sut.advertListVM!))
                XCTAssertTrue(self.advertListVMIsSortedByDate(list: self.sut.advertListVM!, sortType: .descending))
                expectation.fulfill()
            }

        },
        alertMessage: {
            print("\($0)")
            XCTAssertTrue(false)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 10.0)
    }

    func testFilterByIdCategoryAndSortByDateAscending() {
        //Given
        let expectation = XCTestExpectation()
        session.registerTestResponse(Constants.urlAdvertCategory, data: dataCategories)
        session.registerTestResponse(Constants.urlAdvertList, data: dataAdvertList)
        sut.sortByDateCreated = .ascending
        sut.fetchData(success: {
            //When
            self.sut.filterByIdCategoryAndSortByDate(1) {
                //Then
                XCTAssertTrue(self.advertListVMIsSortedByUrgent(list: self.sut.advertListVM!))
                XCTAssertTrue(self.advertListVMIsSortedByDate(list: self.sut.advertListVM!, sortType: .ascending))
                let advertListVMFilter = self.sut.advertListVM?.filter {
                    let advertItem =  $0 as? AdvertItemModel
                    return advertItem?.categoryId != 1
                }
                XCTAssertEqual(advertListVMFilter?.count, 0)
                expectation.fulfill()
            }

        },
        alertMessage: {
            print("\($0)")
            XCTAssertTrue(false)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 10.0)
    }

    func testFilterByIdCategoryAndSortByDateDescending() {
        //Given
        let expectation = XCTestExpectation()
        session.registerTestResponse(Constants.urlAdvertCategory, data: dataCategories)
        session.registerTestResponse(Constants.urlAdvertList, data: dataAdvertList)
        sut.sortByDateCreated = .descending
        sut.fetchData(success: {
            //When
            self.sut.filterByIdCategoryAndSortByDate(1) {
                //Then
                XCTAssertTrue(self.advertListVMIsSortedByUrgent(list: self.sut.advertListVM!))
                XCTAssertTrue(self.advertListVMIsSortedByDate(list: self.sut.advertListVM!, sortType: .descending))
                let advertListVMFilter = self.sut.advertListVM?.filter {
                    let advertItem =  $0 as? AdvertItemModel
                    return advertItem?.categoryId != 1
                }
                XCTAssertEqual(advertListVMFilter?.count, 0)
                expectation.fulfill()
            }

        },
        alertMessage: {
            print("\($0)")
            XCTAssertTrue(false)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 10.0)
    }
    // MARK: - NameCategory delegate
    func testNameCategoryReturnNil() {
        //Given
        let expectation = XCTestExpectation()
        session.registerTestResponse(Constants.urlAdvertCategory, data: dataCategories)
        session.registerTestResponse(Constants.urlAdvertList, data: dataAdvertList)
        sut.fetchData(success: {
            //When
            let nameCategory = self.sut.nameCategory(idCategory: -20)
            XCTAssertNil(nameCategory)
            expectation.fulfill()
        },
        alertMessage: {
            print("\($0)")
            XCTAssertTrue(false)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 10.0)
    }

    // MARK: - AdvertListDataSource
    func testCellListVMReturnCorrectly() {
        //Given
        let expectation = XCTestExpectation()
        session.registerTestResponse(Constants.urlAdvertCategory, data: dataCategories)
        session.registerTestResponse(Constants.urlAdvertList, data: dataAdvertList)
        sut.fetchData(success: {
            //When
            let cellListVM = self.sut.cellListVM

            XCTAssertEqual(cellListVM as? [AdvertItemModel], self.sut.advertListVM as? [AdvertItemModel])
            expectation.fulfill()
        },
        alertMessage: {
            print("\($0)")
            XCTAssertTrue(false)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 10.0)
    }

    // MARK: - function private
    /// check advertListVM is sorted by urgent
    /// - Parameter list: list should be checked
    /// - Returns: list is sorted or no
    private func advertListVMIsSortedByUrgent(list: [AdvertItemViewModel]) -> Bool {
        let listBool = list.map {$0.isUrgentVM}
        if listBool.count == 0 {
            return true
        }

        guard let lastTrue = listBool.lastIndex(of: true), let firstFalse = listBool.firstIndex(of: false) else {
            return true
        }

        return lastTrue < firstFalse
    }

    /// check advertListVM is sorted by date
    /// - Parameters:
    ///   - list: list should be checked
    ///   - sortType: type of sort
    /// - Returns: list is sorted or no
    private func advertListVMIsSortedByDate(list: [AdvertItemViewModel], sortType: KEnum.SortByDate) -> Bool {
        let listBool = list.map {$0.isUrgentVM}
        if listBool.count == 0 {
            return true
        }

        guard let lastTrue = listBool.lastIndex(of: true) else {
            return true
        }

        var result = true
        let subListTrue = list[0...lastTrue]
        let subListFalse = list[lastTrue + 1..<list.count]
        switch sortType {
        case .ascending:
            result = subListTrue.map {$0.creationDateVM}.isAscending()
            result = subListFalse.map {$0.creationDateVM}.isAscending()
        case .descending:
            result = subListTrue.map {$0.creationDateVM}.isDescending()
            result = subListFalse.map {$0.creationDateVM}.isDescending()
        }
        return result
    }
}
