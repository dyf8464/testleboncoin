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
    func nameCategory(idCategory: Int64) -> String?
}
