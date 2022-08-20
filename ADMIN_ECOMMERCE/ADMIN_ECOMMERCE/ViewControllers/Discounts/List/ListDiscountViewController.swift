//
//  ListDiscountViewController.swift
//  ADMIN_ECOMMERCE
//
//  Created by Sang Hi Bùi on 19/08/2022.
//

import UIKit

class ListDiscountViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var listDiscount: [DiscountItem] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var keywordTemp: String = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getListDiscount(keyword: "")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        getListDiscount(keyword: "")
        searchBar.delegate = self
        tableView.register(UINib(nibName: "ListDiscountTableViewCell", bundle: nil), forCellReuseIdentifier: "ListDiscountTableViewCell")

    }
    
    @IBAction func didTapAddNew() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let addNewVC = sb.instantiateViewController(withIdentifier: "AddDiscountViewController") as! AddDiscountViewController
        self.navigationController?.pushViewController(addNewVC, animated: true)
    }
}

extension ListDiscountViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listDiscount.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let discount = listDiscount[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListDiscountTableViewCell", for: indexPath) as! ListDiscountTableViewCell
        cell.binding(discount: discount, indexPath: indexPath)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}

extension ListDiscountViewController {
    private func getListDiscount(keyword: String) {
        APIService.getDiscounts(with: keyword) { res, error in
            guard let res = res, let discounts = res.discounts else {
                return
            }
            self.listDiscount = discounts
        }
    }
}

extension ListDiscountViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        keywordTemp = searchBar.text ?? ""
        view.endEditing(true)
        getListDiscount(keyword: "")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        keywordTemp = searchBar.text ?? ""
        getListDiscount(keyword: keywordTemp ?? "")
    }
}


