//
//  AdvertDetailViewModel.swift
//  testleboncoin
//
//  Created by zhizi yuan on 23/07/2021.
//

import Foundation

protocol AdvertDetailViewModel {
    var detailTitleVM: String {get}
    var detailPriceVM: String {get}
    var detailCreationDateStringVM: String {get}
    var detailIsUrgentVM: Bool {get}
    var detailImageUrl: String? {get}
    var detailDescription: String {get}
}

extension AdvertItemModel: AdvertDetailViewModel {
    var detailTitleVM: String {
        titleVM
    }

    var detailPriceVM: String {
       "Prix : " + priceVM
    }

    var detailCreationDateStringVM: String {
      return creationDate.toString(withFormat: ConstantsUtils.dateFormatJson, toFormat: ConstantsUtils.dateFormatVMd)
    }

    var detailIsUrgentVM: Bool {
        isUrgent
    }

    var detailImageUrl: String? {
        imagesUrl.thumb
    }

    var detailDescription: String {
        description
    }
}
