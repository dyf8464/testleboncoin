//
//  Extension+Date.swift
//  testleboncoin
//
//  Created by zhizi yuan on 19/07/2021.
//

import Foundation

extension String {
    /// convert String to Date with format
    /// - Parameter format: format of String
    /// - Returns: Date created
    func toDate(withFormat format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        guard let date = dateFormatter.date(from: self) else { return nil}
        return date
    }

    /// convert String to new String with desired format
    /// - Parameters:
    ///   - format: current format
    ///   - toFormat: desired format
    /// - Returns: desired String
    func toString(withFormat format: String, toFormat: String) -> String {
        let dateFormatterInput = DateFormatter()
        dateFormatterInput.dateFormat = format

        let dateFormatterOutput = DateFormatter()
        dateFormatterOutput.dateFormat = toFormat

        guard let dateInput = dateFormatterInput.date(from: self) else { return "" }

        return dateFormatterOutput.string(from: dateInput)
    }

}
