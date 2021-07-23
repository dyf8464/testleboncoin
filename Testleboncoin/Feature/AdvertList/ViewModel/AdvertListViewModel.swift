//
//  AdvertListViewModel.swift
//  testleboncoin
//
//  Created by zhizi yuan on 18/07/2021.
//

import Foundation
final class AdvertListViewModel: CategoryNameDelegate {
    /// list of categories from asynchronous
    private(set) var categories: [CategoryModel]?

    /// list of adverts from asynchronous
    private(set) var advertList: [AdvertItemModel]?

    /// list of adverts for display
    private(set) var advertListVM: [AdvertItemViewModel]?

    /// id of Cateogry for its name is "all categories"
    private let idAllCategory: Int64 = -1

    /// provider for all asynchronous tasks
    var apiProvider = APIProvider()



    /// category selected for filter la list items
    private(set) var filterByCategorySelected: CategoryModel?

    /// SettingViewModel for filter by category
    private(set) var filterByCategoryViewModel: SettingViewModel?

    ///  type selected for sort by date
    var sortByDateSelected: KEnum.SortByDate?

    /// SettingViewModel for sort by date
    private(set) var sortByDateViewModel: SettingViewModel?

    /// error message for wrong status code
    static let badResponseMessage: AlertMessage =
        AlertMessage(title: "erreur", message: "Oups, un problème de serveur est survenu... veuillez réessayer ultérieurement.")

    /// error message for wrong format json
    static let jsonDecoderMessage: AlertMessage =
        AlertMessage(title: "erreur", message: "Oups, un problème des données est survenu... veuillez réessayer ultérieurement.")

    /// error message for unkown reason
    static let unKnwonMessage: AlertMessage =
        AlertMessage(title: "erreur", message: "Oups, un problème inconnu est survenu... veuillez réessayer ultérieurement.")

    // MARK: - API
    /// execute all asynchronous tasks in order
    /// - Parameters:
    ///   - success: closure for case success
    ///   - alertMessage: closure for case failure, return alert message
    func fetchData(success: @escaping() -> Void, alertMessage: @escaping(AlertMessage) -> Void) {
        //execute asynchronous tasks in order with DispatchWorkItem
        //download list of adverts
        let fetchAdvertListWorkItem: DispatchWorkItem = DispatchWorkItem {
            self.fetchAdvertList (success: {
                success()
            }, error: {
                alertMessage(self.alertMesssage(error: $0))
            })
        }

        //download list of categories
        self.fetchCateogory(success: {
            DispatchQueue.main.async(execute: fetchAdvertListWorkItem)
        }, error: {
            alertMessage(self.alertMesssage(error: $0))
            fetchAdvertListWorkItem.cancel()
        })

    }

    /// download the Category from server
    /// - Parameters:
    ///   - success: closure for case success
    ///   - error: closure for case failure, return error
    private func fetchCateogory(success: @escaping() -> Void, error: @escaping(Error) -> Void) {
        apiProvider.fetchCategories { [weak self] in
            guard let self = self else {
                return
            }
            switch $0 {
            case let .success(categories) :
                self.categories = categories
                success()
            case let .error(e):
                error(e)
            }
        }
    }

    /// download the list of adverts from server
    /// - Parameters:
    ///   - success: closure for case success
    ///   - error:   closure for case failure, return error
    private func fetchAdvertList(success: @escaping() -> Void, error: @escaping(Error) -> Void) {
        apiProvider.fetchAdvertList { [weak self] in
            guard let self = self else {
                return
            }
            switch $0 {
            case let .success(advertList) :
                self.advertList = advertList
                DispatchQueue.global().async {
                    self.configureAdvertListDelegate()
                    self.advertListVM = self.advertList
                    self.sortAdvertListVMByUrgent()
                    DispatchQueue.main.sync {
                        success()
                    }
                }
            case let .error(e):
                error(e)
            }
        }
    }

    // MARK: - Utils
    /// configure delegate for all element of list
    private func configureAdvertListDelegate() {
        self.advertList?.forEach {
            $0.delegate = self
        }
    }

    /// convert Error to AlertMessage
    private func alertMesssage(error: Error) -> AlertMessage {
        switch error {
        case APIError.jsonDecoder:
            return AdvertListViewModel.jsonDecoderMessage
        case APIError.badResponse:
            return AdvertListViewModel.badResponseMessage
        default:
            return AdvertListViewModel.unKnwonMessage
        }
    }

    // MARK: - Sort
    /// sort advertListVM by urgent
    private func sortAdvertListVMByUrgent() {
        self.advertListVM?.sort {
            $0.isUrgentVM && !$1.isUrgentVM
        }
    }
   /// sort advertListVM by date
    private func sortByDate() {
        guard let sortByDateCreated = sortByDateSelected  else {
            sortAdvertListVMByUrgent()
            return
        }

        switch sortByDateCreated {
        case .ascending:
            self.advertListVM?.sort {
                if $0.isUrgentVM != $1.isUrgentVM {
                    return $0.isUrgentVM
                }
                return  $0.creationDateVM < $1.creationDateVM
            }
        case .descending:
            self.advertListVM?.sort {
                if $0.isUrgentVM != $1.isUrgentVM {
                    return $0.isUrgentVM
                }
                return  $0.creationDateVM > $1.creationDateVM
            }
        }
    }

    /// sort advertListVM by date and completion after sort
    /// - Parameters:
    ///   - sortDate: type of sorting by date
    ///   - completion: action after sorting
    func sortByDate(sortDate: KEnum.SortByDate, completion:@escaping() -> Void) {
        DispatchQueue.global().async {
            self.sortByDateSelected = sortDate
            self.sortByDate()
            DispatchQueue.main.sync {
                completion()
            }
        }
    }

    /// display sorting view
    /// - Parameter completion: action after sorting
    func displaySortByDateView(settingView: SettingView = SettingView.shared, completion:@escaping () -> Void) {
        let viewModel = createSortbyDateViewModel(completion: completion)
        self.sortByDateViewModel = viewModel
        settingView.showSettings(viewModel: viewModel)
    }

    /// create viewModel for sorting view
    /// - Parameter completion: action after sort by date
    private func createSortbyDateViewModel(completion:@escaping () -> Void) -> SettingViewModel {
        let titleFilter = "Trier par"
        //insert new category(name: "all categories") into the list at first poistion
        let sortTypes = [KEnum.SortByDate.descending, KEnum.SortByDate.ascending]

        //init SettingViewModel
        let settingViewModel = SettingViewModel(cellModelList: sortTypes, title: titleFilter, cellModelSelected: self.sortByDateSelected) {
            //get SettingModelView selected and index selected after select a type of sorting in sorting view
            [weak self] settingModelViewSelected, indexSelected in

            guard let self = self, let sortByDate = settingModelViewSelected as? KEnum.SortByDate else {
                return
            }
            //save type sorting selected
            self.sortByDateSelected = sortByDate

            //remove settingViewModel of sorting view
            self.sortByDateViewModel = nil

            //sort list item by type selected
            self.sortByDate(sortDate: sortByDate, completion: completion)
        }
       return settingViewModel
    }

    // MARK: - Filter
    /// filter advertListVM by id of category and sort by date
    /// - Parameters:
    ///   - idCategory: id of Cateogry for filter
    ///   - completion: action after filter and sort
    func filterByIdCategoryAndSortByDate(_ idCategory: Int64, completion:@escaping() -> Void) {
        DispatchQueue.global().async {
            //reinit advertListVM when idAllCategory is selected
            if idCategory == self.idAllCategory {
                self.advertListVM = self.advertList
            } else {
                self.advertListVM = self.advertList?.filter {
                    $0.categoryId == idCategory
                }
            }
            //sort by date
            self.sortByDate()
            DispatchQueue.main.sync {
                completion()
            }
        }
    }

    /// display filtering view
    /// - Parameter completion: action after filter by category
    func displayFilterCategoryView(settingView: SettingView = SettingView.shared, completion:@escaping () -> Void) {
        self.filterByCategoryViewModel = createFilterByCategoryViewModel(completion: completion)
        guard let filterCategoryViewModel = self.filterByCategoryViewModel else {
            return
        }
        settingView.showSettings(viewModel: filterCategoryViewModel)
    }

    /// create viewModel for filtering view
    /// - Parameter completion: action after filter by category
    private func createFilterByCategoryViewModel(completion:@escaping () -> Void) -> SettingViewModel? {
        guard var categories = self.categories
        else {
            return nil
        }
        let titleFilter = "Filtrer par"
        //insert new category(name: "all categories") into the list at first poistion
        let allCategory = CategoryModel(id: idAllCategory, name: "Tous les catégories")
        categories.insert(allCategory, at: 0)

        //init SettingViewModel
        let settingViewModel = SettingViewModel(cellModelList: categories, title: titleFilter, cellModelSelected: self.filterByCategorySelected) {
            //get SettingModelView selected and index selected after select a category in filterView
            [weak self] settingModelViewSelected, indexSelected in

            guard let self = self, let categoryModel = settingModelViewSelected as? CategoryModel else {
                return
            }
            //save categoryModel selected
            self.filterByCategorySelected = categoryModel

            //remove settingViewModel of filtering view
            self.filterByCategoryViewModel = nil

            //action filter list item by id of Category selected
            self.filterByIdCategoryAndSortByDate(categoryModel.id, completion: completion)
        }
       return settingViewModel
    }

}

// MARK: - Protocol AdvertListDataSource
extension AdvertListViewModel: AdvertListDataSource {
    var cellListVM: [AdvertItemViewModel] {
        self.advertListVM ?? [AdvertItemViewModel]()
    }
}
