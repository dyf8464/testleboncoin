//
//  ViewController.swift
//  testleboncoin
//
//  Created by zhizi yuan on 15/07/2021.
//

import UIKit

class AdvertListViewController: UITableViewController {
    let viewModel = AdvertListViewModel()
    let advertCellId = "advertCellId"
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupTableView()
        viewModel.fetchData(success: {
            self.tableView.reloadData()
        }, alertMessage: {
           print("\($0)")
        })

    }

    fileprivate func setupTableView() {
         tableView.backgroundColor = .white
         tableView.separatorStyle = .none
         tableView.register(AdvertCell.self, forCellReuseIdentifier: advertCellId)
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
