//
//  Extension+Image.swift
//  testleboncoin
//
//  Created by zhizi yuan on 18/07/2021.
//

import UIKit

extension UIImageView {
    func asynUrlString(_ urlString: String, imageDefault: UIImage? = nil, session: URLSession = URLSession.shared) {
        guard let url = URL(string: urlString) else {
            self.image = imageDefault
            return
        }
        if let imageFromCache = ImageHelper.imageCache.object(forKey: urlString as AnyObject) {
            self.image = imageFromCache as? UIImage
            return
        }
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
            case .error(_):
                self.image = imageDefault
            }
        }
    }
}
