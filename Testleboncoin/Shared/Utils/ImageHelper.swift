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

    /// Download data from url
    /// - Parameters:
    ///   - session: session for download data, the default is URLSession.shared
    ///   - url: url of data
    ///   - completion: return of result:  Data, URLResponse, Error
    private static func fetchData(session: URLSession, url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        session.dataTask(with: url, completionHandler: completion).resume()
    }

    /// Download image from url
    /// - Parameters:
    ///   - session: session for download image, the default is URLSession.shared
    ///   - url: url of image
    ///   - completion: return result : ImageAPIResult
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
