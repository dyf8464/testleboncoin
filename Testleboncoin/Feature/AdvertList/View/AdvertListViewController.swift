//
//  ViewController.swift
//  testleboncoin
//
//  Created by zhizi yuan on 15/07/2021.
//

import UIKit

class AdvertListViewController: UIViewController {
    let viewModel = AdvertListViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white

        viewModel.fetchData(success: {

        }, alertMessage: {
           print("\($0)")
        })

    }
}
