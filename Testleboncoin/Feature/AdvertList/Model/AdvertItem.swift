//
//  AdvertItem.swift
//  testleboncoin
//
//  Created by zhizi yuan on 16/07/2021.
//

import Foundation

class AdvertItemModel: Codable {
    enum CodingKeys: String, CodingKey {
      case id, title, description, price, siret
      case categoryId = "category_id"
      case creationDate = "creation_date"
      case isUrgent = "is_urgent"
      case imagesUrl = "images_url"

    }
    let id: Int64
    let categoryId: Int64
    let title: String
    let description: String
    let price: Float
    let creationDate: String
    let isUrgent: Bool
    let imagesUrl: ImagesUrlModel
    let siret: String?
    weak var delegate: CategoryNameDelegate?
}

struct ImagesUrlModel: Codable {
    let small: String?
    let thumb: String?
}
