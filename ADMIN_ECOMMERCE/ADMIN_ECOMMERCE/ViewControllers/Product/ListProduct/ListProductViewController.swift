//
//  ListProductViewController.swift
//  ADMIN_ECOMMERCE
//
//  Created by Sang Hi Bùi on 30/07/2022.
//

import UIKit

class ListProductViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var listProduct: [Product] = []
    var keywordTemp: String?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getListProduct(keyword: "")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "List Product"
        searchBar.delegate = self
        setupTableView()

    }

    private func setupTableView() {
        tableView.register(UINib(nibName: "ListProductTableViewCell", bundle: nil), forCellReuseIdentifier: "ListProductTableViewCell")
    }
    
    @IBAction func didTapAddButton() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let addProductVc = sb.instantiateViewController(withIdentifier: "AddProductViewController")
        self.navigationController?.pushViewController(addProductVc, animated: true)
    }
}

extension ListProductViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listProduct.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let product = listProduct[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListProductTableViewCell", for: indexPath) as? ListProductTableViewCell else { return UITableViewCell() }
        cell.bind(product: product)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 184
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {        let product = listProduct[indexPath.row]
        let sb = UIStoryboard(name: "Main", bundle: nil)
        guard let detailProductVC =  sb.instantiateViewController(withIdentifier: "DetailProductViewController") as? DetailProductViewController else { return }
        detailProductVC.productID = product._id ?? ""
        print(product._id)
        self.navigationController?.pushViewController(detailProductVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let product = listProduct[indexPath.row]
        guard let productId = product._id else { return nil }

        let deleteItem = UIContextualAction(style: .destructive, title: "Delete") { (contextualAction, view, boolValue) in
            self.deleteProduct(productID: productId)
            self.listProduct.remove(at: indexPath.row)
            tableView.reloadData()
        }
        let swipeAction = UISwipeActionsConfiguration(actions: [deleteItem])
        return swipeAction
    }
}

extension ListProductViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        keywordTemp = searchBar.text ?? ""
        view.endEditing(true)
        getListProduct(keyword: "")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        keywordTemp = searchBar.text ?? ""
        getListProduct(keyword: keywordTemp ?? "")
    }
}

extension ListProductViewController {
    private func getListProduct(keyword: String) {
        APIService.getListProduct(keyword: keyword) { exploreProducts, error in
            guard let listProduct = exploreProducts?.products else { return }
            self.listProduct = listProduct
            self.tableView.reloadData()
        }
    }
    
    private func deleteProduct(productID: String) {
        APIService.deleteProduct(productID: productID) { [weak self] res, error in
            guard let self = self else { return }
            let alert = UIAlertController(title: res?.message, message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
}
