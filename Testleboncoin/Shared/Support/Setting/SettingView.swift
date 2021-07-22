//
//  SettingView.swift
//  testleboncoinTests
//
//  Created by zhizi yuan on 21/07/2021.
//

import UIKit

protocol SettingViewModelDelegate: AnyObject {
    ///action after setting item is selected
    func settingItemSelectFinished()
}

class SettingView: UIView {
    static let shared = SettingView(settingViewFrame: CGRect(x: 0, y: 0, width: 0, height: 0))

    private(set) var viewModel: SettingViewModel?
    static let settingCellId = "settingCellId"

    lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "cancel"), for: .normal)
        button.addTarget(self, action: #selector(handleDismissSettingView), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let contentView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        view.setRadius(16)
        view.backgroundColor = .white
        return view
    }()

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.register(SettingCell.self, forCellReuseIdentifier: SettingView.settingCellId)
        return tableView
    }()

    weak private var parentWindow: UIWindow?

    convenience init(parentWindow: UIWindow? = UIApplication.shared.keyWindow, settingViewFrame: CGRect) {
        self.init(frame: settingViewFrame)
        self.parentWindow = parentWindow
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(white: 0, alpha: 0.5)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(contentView)
        self.addSubViewsToContentView()
        self.addConstraintsToContentView()

    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    /// configure  all constraints in contentview
    private func addConstraintsToContentView() {
        titleLabel.anchor(top: contentView.topAnchor, bottom: nil, leading: contentView.leadingAnchor, trailing: closeButton.leadingAnchor, padding: .init(top: 25, left: 15, bottom: 0, right: 15))
        closeButton.anchor(top: contentView.topAnchor, bottom: nil, leading: nil, trailing: contentView.trailingAnchor, padding: .init(top: 10, left: 0, bottom: 0, right: 10), size: .init(width: 33.0, height: 33.0))
        tableView.anchor(top: titleLabel.bottomAnchor, bottom: contentView.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, padding: .init(top: 25, left: 15, bottom: 5, right: 15))
    }

    /// add subViews to contentview
    private func addSubViewsToContentView() {
        [titleLabel, tableView, closeButton].forEach {
            contentView.addSubview($0)
        }
    }

    /// pop-up setting view on window
    func showSettings(viewModel: SettingViewModel) {
        self.viewModel = viewModel
        viewModel.settingViewModelDelegate = self
        self.tableView.dataSource = viewModel
        self.tableView.delegate = viewModel
        self.updateContentView()
        animateSettingView()
    }

    ///update subviews of contentview
    private func updateContentView() {
        self.titleLabel.text = self.viewModel?.title
        self.tableView.reloadData()
    }

   /// animate setting view
    private func animateSettingView() {
        if let window = parentWindow {
            self.removeFromSuperview()
            window.addSubview(self)
            self.anchor(top: window.topAnchor, bottom: window.bottomAnchor, leading: window.leadingAnchor, trailing: window.trailingAnchor)

            //Make Hight of slide menu dynamic
            let height: CGFloat = window.frame.height*2/3
            contentView.frame = CGRect(x: 5, y: window.frame.height, width: window.frame.width - 10, height: height)
            self.alpha = 0

            //Implement an ease out curve
            UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.alpha = 1
                self.contentView.frame = CGRect(x: self.contentView.frame.origin.x, y: window.frame.height/6, width: self.contentView.frame.width, height: self.contentView.frame.height)
            }, completion: nil)

        }
    }

    /// close setting view
    @objc func handleDismissSettingView() {
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 0
            self.contentView.frame = CGRect(x: 0, y: self.frame.height, width: self.contentView.frame.width, height: self.contentView.frame.height)
        }, completion: {_ in
            self.viewModel = nil
            self.removeFromSuperview()
        })
    }

}

// MARK: - SettingViewModelDelegate
extension SettingView: SettingViewModelDelegate {
    func settingItemSelectFinished() {
        self.tableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.handleDismissSettingView()
        }
    }
}
