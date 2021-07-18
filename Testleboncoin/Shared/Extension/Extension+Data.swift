//
//  Extension+Data.swift
//  testleboncoin
//
//  Created by zhizi yuan on 17/07/2021.
//

import Foundation

extension Data {
    static func loadFileFromLocalPath(_ localFilePath: String?) -> Data? {
        guard let path = localFilePath else {
            return nil
        }
       return try? Data(contentsOf: URL(fileURLWithPath: path))
    }
}
