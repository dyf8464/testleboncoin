//
//  SettingCellModel.swift
//  testleboncoinTests
//
//  Created by zhizi yuan on 21/07/2021.
//

import Foundation

protocol SettingCellModel {
    var settingCellName: String {get}
}

extension CategoryModel: SettingCellModel {
    var settingCellName: String {
        return name
    }
}

extension KEnum.SortByDate: SettingCellModel {
    var settingCellName: String {
        switch self {
        case .ascending:
            return "Plus anciennes"
        case .descending:
            return "Plus récentes"
        }
    }
}
