//
//  AdvertCell.swift
//  testleboncoin
//
//  Created by zhizi yuan on 20/07/2021.
//

import Foundation


import UIKit

class AdvertCell: UITableViewCell {

    // MARK: - Propeties
    static var imageDefault: UIImage? = UIImage(named: "advertDefaultImage")

    let cellBackground: UIView = {
        let cellBackGround = UIView()
        cellBackGround.setRadius(16)
        cellBackGround.backgroundColor = .leboncoinOrange
        cellBackGround.translatesAutoresizingMaskIntoConstraints = false
        return cellBackGround
    }()

    let advertInfoContainerView: UIView = {
         let containerView = UIView()
          containerView.translatesAutoresizingMaskIntoConstraints = false
          return containerView
      }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let categoryLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.boldSystemFont(ofSize: 15.0)
        label.textColor = .categoryCell
        label.lineBreakMode = .byTruncatingTail
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.italicSystemFont(ofSize: 13.0)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let advertImageView: UIImageView = {
        let advertImageView = UIImageView()
        advertImageView.setRadius(14)
        advertImageView.contentMode = .scaleAspectFill
        advertImageView.translatesAutoresizingMaskIntoConstraints = false
        return advertImageView
    }()

    let urgentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .red
        label.textAlignment = .right
        label.text = "urgent"
        return label
    }()

    let priceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Cell Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        addViewToSubview()
        addConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        if #available(iOS 13, *) {
            super.setSelected(selected, animated: animated)
        } else { // set same behaviour as ios13,  cellBackground.backgroundColor is changed when cell is clicked in ios12
            let color = cellBackground.backgroundColor
            super.setSelected(selected, animated: animated)
            if selected {
                cellBackground.backgroundColor = color
            }
        }
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if #available(iOS 13, *) {
            super.setHighlighted(highlighted, animated: animated)
        } else { // set same behaviour as ios13,  cellBackground.backgroundColor is changed when cell is clicked in ios12
            let color = cellBackground.backgroundColor
            super.setHighlighted(highlighted, animated: animated)
            if highlighted {
                cellBackground.backgroundColor = color
            }
        }
    }

    /// load all elements UI from AdvertItemViewModel
    /// - Parameter viewModel: data source for load UI
    /// - Parameter session: session for async image
    func loadViewModel(viewModel: AdvertItemViewModel, session: URLSession = URLSession.shared) {
        titleLabel.text = viewModel.titleVM
        categoryLabel.text = viewModel.nameCateogryVM
        priceLabel.text = viewModel.priceVM
        dateLabel.text = viewModel.creationDateStringVM
        urgentLabel.isHidden = !viewModel.isUrgentVM
        advertImageView.asyncUrlString(viewModel.smallImageUrl, imageDefault: AdvertCell.imageDefault, session: session)
    }

    // MARK: - Constraints and Add Subview Functions
    /// configure  all constraints
    fileprivate func addConstraints() {
        cellBackground.anchor(top: self.contentView.topAnchor, bottom: self.contentView.bottomAnchor, leading: self.contentView.leadingAnchor, trailing: self.contentView.trailingAnchor, padding: .init(top: 12, left: 16, bottom: 12, right: 16))

        advertInfoContainerView.anchor(top: cellBackground.topAnchor, bottom: cellBackground.bottomAnchor, leading: advertImageView.trailingAnchor, trailing: cellBackground.trailingAnchor)

        advertImageView.anchor(top: cellBackground.topAnchor, bottom: cellBackground.bottomAnchor, leading: cellBackground.leadingAnchor, trailing: nil, padding: .init(top: 5, left: 5, bottom: 5, right: 5), size: .init(width: 90, height: 90))

        categoryLabel.anchor(top: advertInfoContainerView.topAnchor, bottom: titleLabel.topAnchor, leading: advertInfoContainerView.leadingAnchor, trailing: nil, padding: .init(top: 3, left: 5, bottom: 0, right: 0))

        priceLabel.anchor(top: advertInfoContainerView.topAnchor, bottom: titleLabel.topAnchor, leading: categoryLabel.trailingAnchor, trailing: advertInfoContainerView.trailingAnchor, padding: .init(top: 3, left: 0, bottom: 0, right: 10))

        dateLabel.anchor(top: titleLabel.bottomAnchor, bottom: advertInfoContainerView.bottomAnchor, leading: advertInfoContainerView.leadingAnchor, trailing: nil, padding: .init(top: 0, left: 5, bottom: 3, right: 0))

        urgentLabel.anchor(top: titleLabel.bottomAnchor, bottom: advertInfoContainerView.bottomAnchor, leading: nil, trailing: advertInfoContainerView.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 3, right: 10))

        titleLabel.anchor(top: nil, bottom: nil, leading: advertInfoContainerView.leadingAnchor, trailing: advertInfoContainerView.trailingAnchor, padding: .init(top: 0, left: 5, bottom: 0, right: 5))

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: advertInfoContainerView.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalTo: advertInfoContainerView.heightAnchor, multiplier: 0.5),
            categoryLabel.widthAnchor.constraint(equalTo: advertInfoContainerView.widthAnchor, multiplier: 0.5, constant: -5),
            urgentLabel.widthAnchor.constraint(equalTo: advertInfoContainerView.widthAnchor, multiplier: 0.4, constant: -10),
            dateLabel.widthAnchor.constraint(equalTo: advertInfoContainerView.widthAnchor, multiplier: 0.6, constant: -5)
            ])

    }

    /// configure hierarchy of cell
    fileprivate func addViewToSubview() {
        self.contentView.addSubview(cellBackground)
        [advertImageView, advertInfoContainerView].forEach {
            cellBackground.addSubview($0)
        }
        [categoryLabel, priceLabel, titleLabel, dateLabel, urgentLabel].forEach {
            advertInfoContainerView.addSubview($0)
        }
    }

}
