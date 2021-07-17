//
//  APIProvider.swift
//  testleboncoin
//
//  Created by zhizi yuan on 16/07/2021.
//

import Foundation

class APIProvider: RESTAPIClient {
    let baseURL = "https://raw.githubusercontent.com/leboncoin/paperclip/master/"
    let session: URLSession
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    // MARK: - API
    @discardableResult
    func fetchCategories(completion: @escaping (APIResult<[CategoryModel]>) -> Void) -> URLRequest {
        let request = self.advertCategoryRequest()
        requestAPI(with: request, completion: completion)
        return request
    }

    @discardableResult
    func fetchAdvertList(completion: @escaping (APIResult<[AdvertItemModel]>) -> Void) -> URLRequest {
        let request = self.advertListRequest()
        requestAPI(with: request, completion: completion)
        return request
    }

    // MARK: - Request
    private func advertCategoryRequest() -> URLRequest {
        var request = self.request(endPoint: APIEndPoint.advertCategory)
        request.httpMethod = HTTPMethod.get.rawValue
        return request
    }

    private func advertListRequest() -> URLRequest {
        var request = self.request(endPoint: APIEndPoint.advertList)
        request.httpMethod = HTTPMethod.get.rawValue
        return request
    }
}
