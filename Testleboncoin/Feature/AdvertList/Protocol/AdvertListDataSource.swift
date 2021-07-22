//
//  AdvertListDataSource.swift
//  testleboncoin
//
//  Created by zhizi yuan on 21/07/2021.
//

import Foundation

protocol AdvertListDataSource {

    var cellListVM: [AdvertItemViewModel]? {get}
    /// get count of tableview cell
    func countCell() -> Int

    /// get advertItemViewModel by indexPath of tableview
    /// - Parameter indexPath: indexPath of tableview
    func advertItemViewModel(indexPath: IndexPath) -> AdvertItemViewModel
}

extension AdvertListDataSource {
    /// get count of tableviewcell
    func countCell() -> Int {
        return self.cellListVM?.count ?? 0
    }

    /// get advertItemViewModel by indexPath of tableview
    func advertItemViewModel(indexPath: IndexPath) -> AdvertItemViewModel {
        if indexPath.row >= countCell() {
            return AdvertItemModel()
        }

        guard let advertListVM = self.cellListVM else {
            return AdvertItemModel()
        }
        return advertListVM[indexPath.row]
    }
}
