//
//  ImageHelper.swift
//  testleboncoin
//
//  Created by zhizi yuan on 18/07/2021.
//

import Foundation
enum ImageAPIResult<T> {
    case success(T)
    case error(Error)
}

final class ImageHelper {
    struct ImageHelperError: Error {

    }

    static var imageCache: NSCache<AnyObject, AnyObject>! = NSCache<AnyObject, AnyObject>()
    private static func fetchData(session: URLSession, url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        session.dataTask(with: url, completionHandler: completion).resume()
    }

    static func fetchImage(session: URLSession = URLSession.shared, url: URL, completion: @escaping(ImageAPIResult<Data>) -> Void) {
        ImageHelper.fetchData(session: session, url: url) { data, response, error in
            if let error = error {
                completion(.error(error))
                return
            }

            guard let data = data else {
                completion(.error(ImageHelperError()))
                return
            }

            DispatchQueue.main.async {
                completion(.success(data))
            }
        }
    }
}
