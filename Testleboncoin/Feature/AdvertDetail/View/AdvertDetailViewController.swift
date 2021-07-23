//
//  AdvertDetailViewController.swift
//  testleboncoin
//
//  Created by zhizi yuan on 23/07/2021.
//

import UIKit

class AdvertDetailViewController: UIViewController {
    var viewModel: AdvertDetailViewModel?
    let labelMargin: CGFloat = 10.0
    let labelSpacing: CGFloat = 10.0
    let defaultImage = UIImage(named: "advertDefaultImage")

    let contentView: UIView  = {
        let contentView = UIView()
        contentView.backgroundColor = .white
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()

    let closeButton: UIButton  = {
        let button = UIButton()
        button.alpha = 0.5
        button.setBackgroundImage(UIImage(named: "detail_close"), for: .normal)
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let scrollView: UIScrollView  = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    let scrollContentView: UIView  = {
        let scrollContentView = UIView()
        scrollContentView.backgroundColor = .white
        scrollContentView.translatesAutoresizingMaskIntoConstraints = false
        return scrollContentView
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.italicSystemFont(ofSize: 13.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let advertImageView: UIImageView = {
        let advertImageView = UIImageView()
        advertImageView.contentMode = .scaleAspectFill
        advertImageView.translatesAutoresizingMaskIntoConstraints = false
        return advertImageView
    }()

    let urgentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .red
        label.font = UIFont.italicSystemFont(ofSize: 13.0)
        label.text = "urgent"
        return label
    }()

    let priceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .leboncoinOrange
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let descriptionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Description"
        label.textColor = .leboncoinOrange
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let separatorView: UIView = {
        let separatorView = UIView()
        separatorView.backgroundColor = .gray
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        return separatorView
    }()

    /// close view controller
    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .leboncoinOrange
        self.addSubviews()
        self.addConstraints()
        self.setupSubviews()
    }

    // MARK: - Constraints and Add Subview Functions
    /// configure  all constraints
    fileprivate func addConstraints() {
        self.contentViewAddConstraintsSafearea()
        scrollView.anchor(top: self.contentView.topAnchor, bottom: self.contentView.bottomAnchor, leading: self.contentView.leadingAnchor, trailing: self.contentView.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))

        closeButton.anchor(top: self.contentView.topAnchor, bottom: nil, leading: nil, trailing: self.contentView.trailingAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 20), size: .init(width: 50, height: 50))

        scrollContentView.anchor(top: self.scrollView.topAnchor, bottom: self.scrollView.bottomAnchor, leading: self.scrollView.leadingAnchor, trailing: self.scrollView.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))

        advertImageView.anchor(top: scrollContentView.topAnchor, bottom: nil, leading: scrollContentView.leadingAnchor, trailing: scrollContentView.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))

        titleLabel.anchor(top: advertImageView.bottomAnchor, bottom: nil, leading: scrollContentView.leadingAnchor, trailing: scrollContentView.trailingAnchor, padding: .init(top: labelSpacing, left: labelMargin, bottom: 0, right: labelMargin))

        priceLabel.anchor(top: titleLabel.bottomAnchor, bottom: nil, leading: scrollContentView.leadingAnchor, trailing: nil, padding: .init(top: labelSpacing, left: labelMargin, bottom: 0, right: 0))

        dateLabel.anchor(top: priceLabel.bottomAnchor, bottom: nil, leading: scrollContentView.leadingAnchor, trailing: nil, padding: .init(top: labelSpacing, left: labelMargin, bottom: 0, right: 0))

        separatorView.anchor(top: dateLabel.bottomAnchor, bottom: nil, leading: scrollContentView.leadingAnchor, trailing: scrollContentView.trailingAnchor, padding: .init(top: labelSpacing, left: labelMargin, bottom: 0, right: labelSpacing), size: .init(width: 0, height: 1))

        urgentLabel.anchor(top: nil, bottom: separatorView.topAnchor, leading: nil, trailing: scrollContentView.trailingAnchor, padding: .init(top: 0 , left:0 , bottom: labelSpacing, right: labelMargin))

        descriptionTitleLabel.anchor(top: separatorView.bottomAnchor, bottom: nil, leading: scrollContentView.leadingAnchor, trailing: nil, padding: .init(top: labelSpacing, left: labelSpacing, bottom: labelSpacing, right: 0))

        descriptionLabel.anchor(top: descriptionTitleLabel.bottomAnchor, bottom: self.scrollContentView.bottomAnchor, leading: scrollContentView.leadingAnchor, trailing: scrollContentView.trailingAnchor, padding: .init(top: labelSpacing, left: labelMargin, bottom: labelSpacing, right: labelMargin))

        NSLayoutConstraint.activate([
            advertImageView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.5),
            scrollContentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor)
        ])
    }

    /// configure contentview safearea
    fileprivate func contentViewAddConstraintsSafearea() {
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalToSystemSpacingBelow: guide.topAnchor, multiplier: 1.0),
            guide.bottomAnchor.constraint(equalToSystemSpacingBelow: contentView.bottomAnchor, multiplier: 1.0)
        ])
    }

    /// configure hierarchy of cell
    fileprivate func addSubviews() {
        self.view.addSubview(contentView)
        [scrollView, closeButton].forEach {
            contentView.addSubview($0)
        }
        self.scrollView.addSubview(scrollContentView)

        [advertImageView, titleLabel, priceLabel, dateLabel, separatorView, descriptionTitleLabel, descriptionLabel, urgentLabel].forEach {
            scrollContentView.addSubview($0)
        }
    }

    func setupSubviews() {
        guard let viewModel = viewModel else {
            return
        }
        self.advertImageView.asyncUrlString(self.viewModel?.detailImageUrl,imageDefault: defaultImage)
        self.titleLabel.text = viewModel.detailTitleVM
        self.priceLabel.text = viewModel.detailPriceVM
        self.dateLabel.text = viewModel.detailCreationDateStringVM
        self.descriptionLabel.text = viewModel.detailDescription
        self.urgentLabel.isHidden = !viewModel.detailIsUrgentVM
    }

}
