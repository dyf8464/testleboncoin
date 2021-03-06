//
//  AdvertItemViewModel.swift
//  testleboncoin
//
//  Created by zhizi yuan on 19/07/2021.
//

import Foundation

protocol AdvertItemViewModel {
    var titleVM: String {get}
    var nameCateogryVM: String {get}
    var priceVM: String {get}
    var creationDateVM: Date {get}
    var creationDateStringVM: String {get}
    var isUrgentVM: Bool {get}
    var smallImageUrl: String? {get}
}

extension AdvertItemModel: AdvertItemViewModel {

    var smallImageUrl: String? {
        imagesUrl.small
    }

    var titleVM: String {
        title
    }

    var nameCateogryVM: String {
        guard let delegate = self.delegate else {
            return ""
        }
        return delegate.nameCategory(idCategory: categoryId) ?? ""
    }

    var priceVM: String {
        let s = String(format: "%.2f", price)
        return s  + " €"
    }

    var creationDateVM: Date {
        creationDate.toDate(withFormat: ConstantsUtils.dateFormatJson) ?? Date()
    }

    var creationDateStringVM: String {
        creationDate.toString(withFormat: ConstantsUtils.dateFormatJson, toFormat: ConstantsUtils.dateFormatVM)
    }

    var isUrgentVM: Bool {
        isUrgent
    }
}
