//
//  ViewController.swift
//  testleboncoin
//
//  Created by zhizi yuan on 15/07/2021.
//

import UIKit

class AdvertListViewController: UITableViewController {
    lazy var filterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "filter_category")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 33, height: 33)
        button.addTarget(self, action: #selector(filterClick), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    lazy var sortButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "sort_date")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 33, height: 33)
        button.addTarget(self, action: #selector(sortClick), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let viewModel = AdvertListViewModel()
    let advertCellId = "advertCellId"
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupTableView()
        self.configureBarButtonItems()
        //get data from API
        self.fectchData()

    }

    ///display error message API
    private func displayErrorMessage(_ alertMessage: AlertMessage) {
        let alertController = UIAlertController(title: alertMessage.title, message: alertMessage.message, preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "Fermer", style: .cancel)
        alertController.addAction(closeAction)

        let retryAction = UIAlertAction(title: "Réessayer", style: .default) { _ in
            self.fectchData()
        }
        alertController.addAction(retryAction)

        present(alertController, animated: true)
    }

    /// get data from API
    private func fectchData() {
        viewModel.fetchData(success: { [weak self] in
            guard let self = self else {
                return
            }
            self.tableView.reloadData()
        }, alertMessage: { [weak self] in
            guard let self = self else {
                return
            }
            self.displayErrorMessage($0)
        })
    }

    /// configure tableview
    private func setupTableView() {
         tableView.backgroundColor = .white
         tableView.separatorStyle = .none
         tableView.register(AdvertCell.self, forCellReuseIdentifier: advertCellId)
     }

    /// action for click filter button
    @objc fileprivate func filterClick() {
        viewModel.displayFilterCategoryView { [weak self] in
            guard let self = self else {
                return
            }
            self.tableView.reloadData()
        }
    }

    /// action for click filter button
    @objc fileprivate func sortClick() {
        viewModel.displaySortByDateView { [weak self] in
            guard let self = self else {
                return
            }
            self.tableView.reloadData()
        }
    }

    ///configure ButtonItems: filter, sort
    fileprivate func configureBarButtonItems() {
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: filterButton), UIBarButtonItem(customView: sortButton)]
    }
}

// MARK: - UITableView Data Source
extension AdvertListViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        viewModel.countCell()

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard  let cell = tableView.dequeueReusableCell(withIdentifier: advertCellId, for: indexPath) as? AdvertCell else {
            return UITableViewCell()
        }
        cell.loadViewModel(viewModel: viewModel.advertItemViewModel(indexPath: indexPath))
        return cell
    }
}
