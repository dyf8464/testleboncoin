//
//  EndPoint.swift
//  testleboncoin
//
//  Created by zhizi yuan on 15/07/2021.
//

import Foundation
protocol EndPoint {
    /// url of endPoint
    var endPointURL: String { get }
}

enum APIEndPoint: EndPoint {
    /// url of endPoint
    var endPointURL: String {
        switch self {
        case .advertList:
           return "listing.json"
        case .advertCategory:
           return "categories.json"
        }
    }
    /// list of adverts
    case advertList
    /// category of adverts
    case advertCategory
}
