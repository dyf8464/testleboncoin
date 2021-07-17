//
//  EndPoint.swift
//  testleboncoin
//
//  Created by zhizi yuan on 15/07/2021.
//

import Foundation
protocol EndPoint {
    var endPointURL: String { get }
}

enum APIEndPoint: EndPoint {
    var endPointURL: String {
        switch self {
        case .advertList:
           return "listing.json"
        case .advertCategory:
           return "categories.json"
        }
    }

    case advertList
    case advertCategory
}
