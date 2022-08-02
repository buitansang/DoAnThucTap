//
//  ListOrderViewController.swift
//  ADMIN_ECOMMERCE
//
//  Created by Sang Hi Bùi on 31/07/2022.
//

import UIKit

class ListOrderViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getListOrder()
    }
}

extension ListOrderViewController {
    private func getListOrder() {
        APIService.getListOrder { listOrder, error in
            guard let listOrder = listOrder else {
                return
            }
            print(listOrder.success)
        }
    }
}

