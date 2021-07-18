//
//  AdvertListViewModel.swift
//  testleboncoin
//
//  Created by zhizi yuan on 18/07/2021.
//

import Foundation
final class AdvertListViewModel {
    private(set) var categories: [CategoryModel]?
    private(set) var advertList: [AdvertItemModel]?
    var apiProvider = APIProvider()
    static let badResponseMessage: AlertMessage =
        AlertMessage(title: "erreur", message: "Oups, un problème de serveur est survenu... veuillez réessayer ultérieurement.")

    static let jsonDecoderMessage: AlertMessage =
        AlertMessage(title: "erreur", message: "Oups, un problème des données est survenu... veuillez réessayer ultérieurement.")

    static let unKnwonMessage: AlertMessage =
        AlertMessage(title: "erreur", message: "Oups, un problème inconnu est survenu... veuillez réessayer ultérieurement.")

    // MARK: - API
    //récupération tous les données
    func fetchData(success: @escaping() -> Void, alertMessage: @escaping(AlertMessage) -> Void) {
        //récupération de la liste des catégories
        let fetchAdvertListWorkItem: DispatchWorkItem = DispatchWorkItem {
            self.fetchAdvertList (success: {
                success()
            }, error: {
                alertMessage(self.alertMesssage(error: $0))
            })
        }

        //récupération des catégories
        self.fetchCateogory(success: {
            DispatchQueue.main.async(execute: fetchAdvertListWorkItem)
        }, error: {
            alertMessage(self.alertMesssage(error: $0))
            fetchAdvertListWorkItem.cancel()
        })

    }

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

    private func fetchAdvertList(success: @escaping() -> Void, error: @escaping(Error) -> Void) {
        apiProvider.fetchAdvertList {
            switch $0 {
            case let .success(advertList) :
                self.advertList = advertList
                DispatchQueue.global().async {
                    self.configurationAdvertList()
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
    private func configurationAdvertList() {
        self.advertList?.forEach {
            $0.delegate = self
        }
    }

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
// MARK: - CategoryNameDelegate
extension AdvertListViewModel: CategoryNameDelegate {
    func nameCategory(idCategory: Int64) -> String? {
        if let categoriesFilter = self.categories?.filter({$0.id == idCategory}) {
            if categoriesFilter.count > 0 {
                return categoriesFilter[0].name
            }
        }
       return nil
    }
}
