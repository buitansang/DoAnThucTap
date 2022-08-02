//
//  ListCustormerViewController.swift
//  ADMIN_ECOMMERCE
//
//  Created by Sang Hi Bùi on 31/07/2022.
//

import UIKit

class ListCustomerViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var keywordTemp: String?
    var listCustomer: [Customer] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "List Customer"
        searchBar.delegate = self
        getListCustomer(keyword: "")
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: "ListCustomerTableViewCell", bundle: nil), forCellReuseIdentifier: "ListCustomerTableViewCell")
    }
}

extension ListCustomerViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        listCustomer.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let customer = listCustomer[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListCustomerTableViewCell", for: indexPath) as? ListCustomerTableViewCell else { return UITableViewCell() }
        cell.bind(customer: customer)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 184
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let customerID = listCustomer[indexPath.row]._id ?? ""
        let sb = UIStoryboard(name: "Main", bundle: nil)
        guard let detailCustomerVC = sb.instantiateViewController(withIdentifier: "DetailCustomerViewController") as? DetailCustomerViewController else { return }
        detailCustomerVC.customerID = customerID
        self.navigationController?.pushViewController(detailCustomerVC, animated: true)
    }
}

extension ListCustomerViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        keywordTemp = searchBar.text ?? ""
        view.endEditing(true)
        getListCustomer(keyword: "")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        keywordTemp = searchBar.text ?? ""
        getListCustomer(keyword: keywordTemp ?? "")
    }
}

extension ListCustomerViewController {
    private func getListCustomer(keyword: String) {
        APIService.getListCustomer(keyword: keyword) { customers, error in
            print(customers?.users.count)
            guard let users = customers?.users else {
                return
            }

            self.listCustomer = users
        }
    }
}
