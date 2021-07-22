//
//  SettingCell.swift
//  testleboncoinTests
//
//  Created by zhizi yuan on 21/07/2021.
//

import UIKit

class SettingCell: UITableViewCell {

    // MARK: - Propeties
    static let imageSelected: UIImage = UIImage(named: "setting_cell_selected")!
    static let imageUnselected: UIImage = UIImage(named: "setting_cell_unselected")!

    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let selectImageView: UIImageView = {
        let selectImageView = UIImageView()
        selectImageView.translatesAutoresizingMaskIntoConstraints = false
        return selectImageView
    }()

    // MARK: - Cell Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        self.selectionStyle = .none
        addViewToSubview()
        addConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - Constraints and Add Subview Functions
    /// configure  all constraints
    fileprivate func addConstraints() {
        titleLabel.anchor(top: contentView.topAnchor, bottom: contentView.bottomAnchor, leading: contentView.leadingAnchor, trailing: selectImageView.leadingAnchor, padding: .init(top: 5, left: 5, bottom: 5, right: 5))

        selectImageView.anchor(top: nil, bottom: nil, leading: nil, trailing: contentView.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 5), size: .init(width: 33, height: 33))

        NSLayoutConstraint.activate([
            selectImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
            ])

    }

    /// configure hierarchy of cell
    fileprivate func addViewToSubview() {
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(selectImageView)
    }

    // MARK: - Load data
    func loadModel(_ model: SettingCellModel, isSelected: Bool) {
        self.titleLabel.text = model.settingCellName
        selectImageView.image = isSelected ? SettingCell.imageSelected : SettingCell.imageUnselected
    }
}
