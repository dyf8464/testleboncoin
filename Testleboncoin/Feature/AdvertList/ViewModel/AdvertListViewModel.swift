//
//  AdvertListViewModel.swift
//  testleboncoin
//
//  Created by zhizi yuan on 18/07/2021.
//

import Foundation
final class AdvertListViewModel: CategoryNameDelegate {
    /// list of categories
    private(set) var categories: [CategoryModel]? {
        didSet {
            //add new category(name: "all categories") into the list for function filter
            let allCategory = CategoryModel(id: idAllCategory, name: "tous les catégories")
            categories?.append(allCategory)
        }
    }
    /// list of adverts from aynchro
    private(set) var advertList: [AdvertItemModel]?

    /// list of adverts for display
    private(set) var advertListVM: [AdvertItemViewModel]?

    /// id of Cateogry for its name is "all categories"
    private let idAllCategory: Int64 = -1

    /// provider for all asynchronous tasks
    var apiProvider = APIProvider()

    /// indice of sort date
    var sortByDateCreated: KEnum.SortByDate?

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
        apiProvider.fetchCategories {
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
        apiProvider.fetchAdvertList {
            switch $0 {
            case let .success(advertList) :
                self.advertList = advertList
                DispatchQueue.global().async {
                    self.configurationAdvertListDelegate()
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
    /// configuration delegate for all element of list
    private func configurationAdvertListDelegate() {
        self.advertList?.forEach {
            $0.delegate = self
        }
    }

    /// sort advertListVM by urgent
    private func sortAdvertListVMByUrgent() {
        self.advertListVM?.sort {
            $0.isUrgentVM && !$1.isUrgentVM
        }
    }

   /// sort advertListVM by date
    private func sortByDate() {
        guard let sortByDateCreated = sortByDateCreated  else {
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
    ///   - sortDate: type of sort date
    ///   - completion: action after sort
    func sortByDate(sortDate: KEnum.SortByDate, completion:@escaping() -> Void) {
        DispatchQueue.global().async {
            self.sortByDateCreated = sortDate
            self.sortByDate()
            DispatchQueue.main.sync {
                completion()
            }
        }
    }

    /// filter advertListVM by id of category and sort by date
    /// - Parameters:
    ///   - idCategory: id of Cateogry for filter
    ///   - completion: action after filter and sort
    func filterByIdCategoryAndSortByDate(_ idCategory: Int64, completion:@escaping() -> Void) {
        DispatchQueue.global().async {
            if idCategory == self.idAllCategory {
                self.advertListVM = self.advertList
            } else {
                self.advertListVM = self.advertList?.filter {
                    $0.categoryId == idCategory
                }
            }
            self.sortByDate()
            DispatchQueue.main.sync {
                completion()
            }
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
}
