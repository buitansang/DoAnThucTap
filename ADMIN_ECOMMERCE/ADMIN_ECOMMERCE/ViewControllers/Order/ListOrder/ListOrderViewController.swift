//
//  ListOrderViewController.swift
//  ADMIN_ECOMMERCE
//
//  Created by Sang Hi Bùi on 31/07/2022.
//

import UIKit

class ListOrderViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var listOrderDisplay: [Order] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    var listOrder: [Order] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getListOrder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "List Order"
        getListOrder()
        setupTableView()
        configData()
    }
    private func configData() {
        segmentedControl.selectedSegmentIndex = 0
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: "ListOrderTableViewCell", bundle: nil), forCellReuseIdentifier: "ListOrderTableViewCell")
    }
    
    @IBAction func switchStatus(_ sender: UISegmentedControl) {
        getListOrder()
        if segmentedControl.selectedSegmentIndex == 0 {
            listOrderDisplay = listOrder.filter { $0.orderStatus == "Processing" }
        } else if segmentedControl.selectedSegmentIndex == 1 {
            listOrderDisplay = listOrder.filter { $0.orderStatus == "Confirmed" }
        } else if segmentedControl.selectedSegmentIndex == 2 {
            listOrderDisplay = listOrder.filter { $0.orderStatus == "Delivered" }
        } else if segmentedControl.selectedSegmentIndex == 3 {
            listOrderDisplay = listOrder.filter { $0.orderStatus == "Complete" }
        } else {
            listOrderDisplay = listOrder.filter { $0.orderStatus == "Cancel" }
        }
    }
}

extension ListOrderViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOrderDisplay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let order = listOrderDisplay[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListOrderTableViewCell", for: indexPath) as? ListOrderTableViewCell else { return UITableViewCell() }
        cell.bind(order: order)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let order = listOrderDisplay[indexPath.row]
        let sb = UIStoryboard(name: "Main", bundle: nil)
        guard let detailOrderVC = sb.instantiateViewController(withIdentifier: "DetailOrderViewController") as? DetailOrderViewController else { return }
        detailOrderVC.orderID = order._id ?? ""
        self.navigationController?.pushViewController(detailOrderVC, animated: true)
    }
}

extension ListOrderViewController {
    private func getListOrder() {
        APIService.getListOrder { [weak self] res, error in
            guard let self = self else { return }
            guard let list = res?.orders else {
                return
            }
            
            self.listOrder = list.reversed()
            if self.segmentedControl.selectedSegmentIndex == 0 {
                self.listOrderDisplay = self.listOrder.filter { $0.orderStatus == "Processing" }
            }
        }
    }
}

