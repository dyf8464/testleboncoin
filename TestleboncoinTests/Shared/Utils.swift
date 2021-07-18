//
//  Utils.swift
//  testleboncoinTests
//
//  Created by zhizi yuan on 18/07/2021.
//

import Foundation

struct Constants {
    // MARK: - JSON
    static let urlAdvertCategory = URL(string: "https://raw.githubusercontent.com/leboncoin/paperclip/master/categories.json")!

    static let urlAdvertList = URL(string: "https://raw.githubusercontent.com/leboncoin/paperclip/master/listing.json")!

    static let testAdvertListFileName = "advertList"
    static let testAdvertListErrorFileName = "advertList_error"

    static let testCategoryFileName = "category"
    static let testCategoryErrorFileName = "category_error"

    // MARK: - Image
    static let urlTestImage = URL(string: "https://raw.githubusercontent.com/leboncoin/paperclip/master/ad-small/2c9563bbe85f12a5dcaeb2c40989182463270404.jpg")!
    static let testImageName = "image_mock"
    static let testDefaultImageName = "image_default_mock"
}
