//
//  CategoryNameDelegate.swift
//  testleboncoin
//
//  Created by zhizi yuan on 17/07/2021.
//

import Foundation
protocol CategoryNameDelegate: AnyObject {
    /// get name of category by id
    /// - Parameter idCategory: id of category
    /// - Returns: name of category
    var categories: [CategoryModel]? {get}
    func nameCategory(idCategory: Int64) -> String?
}

extension CategoryNameDelegate {
    func nameCategory(idCategory: Int64) -> String? {
        if let categoriesFilter = self.categories?.filter({$0.id == idCategory}) {
            if categoriesFilter.count > 0 {
                return categoriesFilter[0].name
            }
        }
        return nil
    }
}
