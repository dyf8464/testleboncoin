//
//  AdvertListDataSource.swift
//  testleboncoin
//
//  Created by zhizi yuan on 21/07/2021.
//

import Foundation

protocol AdvertListDataSource {

    var cellListVM: [AdvertItemViewModel] {get}
    /// get count of tableview cell
    func countCell() -> Int

    /// get advertItemViewModel by indexPath of tableview
    /// - Parameter indexPath: indexPath of tableview
    func advertItemViewModel(indexPath: IndexPath) -> AdvertItemViewModel


    func createAdvertDetailViewController(indexPath: IndexPath) -> AdvertDetailViewController
}

extension AdvertListDataSource {
    /// get count of tableviewcell
    func countCell() -> Int {
        return self.cellListVM.count
    }

    /// get advertItemViewModel by indexPath of tableview
    func advertItemViewModel(indexPath: IndexPath) -> AdvertItemViewModel {
        if indexPath.row >= countCell() {
            return AdvertItemModel()
        }
        return cellListVM[indexPath.row]
    }

    /// get advertItemViewModel by indexPath of tableview
    func createAdvertDetailViewController(indexPath: IndexPath) -> AdvertDetailViewController {
        let advertDetailViewController = AdvertDetailViewController()
        advertDetailViewController.viewModel = self.advertItemViewModel(indexPath: indexPath) as? AdvertDetailViewModel
        return advertDetailViewController
    }
}
