//
//  CategoryNameDelegate.swift
//  testleboncoin
//
//  Created by zhizi yuan on 17/07/2021.
//

import Foundation
protocol CategoryNameDelegate: AnyObject {
    func nameCategory(idCategory: Int64) -> String?
}
