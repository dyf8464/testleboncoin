//
//  SettingViewModel.swift
//  testleboncoinTests
//
//  Created by zhizi yuan on 21/07/2021.
//

import UIKit
class SettingViewModel: NSObject {
    var settingCellId = SettingView.settingCellId
    private(set)  var selectedCompletion: (SettingCellModel, Int) -> Void
    private(set) var title: String
    private(set) var cellModelList: [SettingCellModel]
    private(set) var cellModelSelected: SettingCellModel?
    weak var settingViewModelDelegate: SettingViewModelDelegate?
    private(set) var nameSelecting: String?
    /// init
    /// - Parameters:
    ///   - cellModelList: data source for setting table view
    ///   - title: title of setting view
    ///   - cellModelSelected: setting item selected
    init(cellModelList: [SettingCellModel], title: String, cellModelSelected: SettingCellModel?, completion: @escaping (SettingCellModel, Int) -> Void) {
        self.cellModelList = cellModelList
        self.title = title
        self.cellModelSelected = cellModelSelected
        self.selectedCompletion = completion
    }

    /// check SettingCellModel is selected
    /// - Parameter model: SettingCellModel needs to be checked
    /// - Returns: SettingCellModel is checked or no
    private func modelIsSelected(model: SettingCellModel) -> Bool {
        if self.nameSelecting == model.settingCellName {
            return true
        }
        guard let cellModelSelected = self.cellModelSelected else {
            return false
        }

        return cellModelSelected.settingCellName == model.settingCellName
    }
}

// MARK: - UITableViewDataSource
extension SettingViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.cellModelList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: settingCellId, for: indexPath) as? SettingCell else {
            return UITableViewCell()
        }

        if indexPath.row >= self.cellModelList.count {
            return UITableViewCell()
        }
        let modelCell = self.cellModelList[indexPath.row]
        cell.loadModel(modelCell, isSelected: modelIsSelected(model: modelCell))
        return cell
    }
}

extension SettingViewModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row >= self.cellModelList.count {
            return
        }
        let modelCell = self.cellModelList[indexPath.row]
        self.nameSelecting = modelCell.settingCellName
        self.cellModelSelected = nil
        self.selectedCompletion(modelCell, indexPath.row)
        self.settingViewModelDelegate?.settingItemSelectFinished()
    }
}
