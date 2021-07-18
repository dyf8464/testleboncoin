//
//  APIRESTClient.swift
//  testleboncoin
//
//  Created by zhizi yuan on 15/07/2021.
//

import Foundation

enum APIResult<T> {
    case success(T), error(Error)
}

enum APIError: Error {
    case unknown, badResponse, jsonDecoder
}

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

protocol RESTAPIClient {
    var baseURL: String { get }
    var session: URLSession { get }
    func requestAPI<T: Codable>(with request: URLRequest, completion: @escaping (APIResult<T>) -> Void)
}

extension RESTAPIClient {

    private func urlComponent(endPoint: EndPoint) -> URLComponents {
        let urlString = baseURL + endPoint.endPointURL
        let component = URLComponents(string: urlString)
        return component!
    }

    func request(endPoint: EndPoint) -> URLRequest {
        return URLRequest(url: self.urlComponent(endPoint: endPoint).url!)
    }

    func requestAPI<T: Codable>(with request: URLRequest, completion: @escaping (APIResult<T>) -> Void) {
        let task = session.dataTask(with: request) { (data, response, error) in
            guard error == nil
            else {
                DispatchQueue.main.async {
                    completion(.error(error!))
                }
                return
            }
            guard let response = response as? HTTPURLResponse, 200..<300 ~= response.statusCode
            else {
                DispatchQueue.main.async {
                    completion(.error(APIError.badResponse))
                }
                return
            }

            guard let data = data else { return }

            guard let value = try? JSONDecoder().decode(T.self, from: data)
            else {
                DispatchQueue.main.async {
                    completion(.error(APIError.jsonDecoder))
                }
                return
            }
            DispatchQueue.main.async {
                completion(.success(value))
            }
        }
        task.resume()
    }

}
