//
//  Extension+Array.swift
//  testleboncoin
//
//  Created by zhizi yuan on 20/07/2021.
//

import Foundation
extension Array where Element: Comparable {
    /// check array is sorted in ascending
    func isAscending() -> Bool {
        return zip(self, self.dropFirst()).allSatisfy(<=)
    }

    /// check array is sorted in descending
    func isDescending() -> Bool {
        return zip(self, self.dropFirst()).allSatisfy(>=)
    }
}
