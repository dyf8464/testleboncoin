//
//  Extension+Image.swift
//  testleboncoin
//
//  Created by zhizi yuan on 18/07/2021.
//

import UIKit

extension UIImageView {
    /// This function download image from url and save into cache
    /// - Parameter urlString: url of image.
    /// - Parameter imageDefault: default image.
    /// - Parameter session: session for asynchronous, the default is : URLSession.shared.
    func asyncUrlString(_ urlString: String?, imageDefault: UIImage? = nil, session: URLSession = URLSession.shared) {
        guard let urlString = urlString else {
            self.image = imageDefault
            return
        }

        guard let url = URL(string: urlString) else {
            self.image = imageDefault
            return
        }
        if let imageFromCache = ImageHelper.imageCache.object(forKey: urlString as AnyObject) {
            self.image = imageFromCache as? UIImage
            return
        }
        self.image = imageDefault
        ImageHelper.fetchImage(session: session, url: url) { [weak self] reslut in
            guard let self = self else {
                return
            }
            switch reslut {
            case .success(let data):
                guard let imageDownload = UIImage(data: data) else {
                    self.image = imageDefault
                    return
                }
                ImageHelper.imageCache.setObject(imageDownload, forKey: urlString as AnyObject)
                self.image = imageDownload
            case .error(let error):
                print("async image error :\(error)")
            }
        }
    }
}
