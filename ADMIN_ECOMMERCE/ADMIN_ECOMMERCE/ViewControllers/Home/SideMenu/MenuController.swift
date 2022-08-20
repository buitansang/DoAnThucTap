//
//  MenuController.swift
//  ADMIN_ECOMMERCE
//
//  Created by Sang Hi Bùi on 24/07/2022.
//

import UIKit

protocol MenuControllerDelegate {
    func didSelectMenuItem(name: String)
}

class MenuController: UITableViewController {
    
    enum MenuOptions: String, CaseIterable {
        case products = "Managed Products"
        case orders = "Managed Orders"
        case customers = "Managed Customer"
        case discounts = "Managed Discount"
        case analytics = "Analytics"
        case logout = "Logout"
        
        var imageName: String {
            switch self {
            case .products:
                return "products"
            case .orders:
                return "orders"
            case .customers:
                 return "customers"
            case .discounts:
                return "orders"
            case .analytics:
                return "analytics"
            case .logout:
                return "logout"
            }
        
        }
    }
    
    public var delegate: MenuControllerDelegate?

    private let menuItems: [String]
    
    init(with menuItems: [String]) {
        self.menuItems = menuItems
        super.init(nibName: nil, bundle: nil)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//        tableView.register(TableHeader.self, forHeaderFooterViewReuseIdentifier: TableHeader.identifier)
//        tableView.register(TableFooter.self, forHeaderFooterViewReuseIdentifier: TableFooter.identifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  UINavBar.clear(self.navigationItem)
      //  tableView.backgroundColor = UIColor.blueCustom()
        tableView.isScrollEnabled = false
     //   view.backgroundColor = UIColor.blueCustom()
        
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuOptions.allCases.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        let menuItem = menuItems[indexPath.row]
        cell.textLabel?.text = MenuOptions.allCases[indexPath.row].rawValue
        cell.textLabel?.textColor = .black
        cell.imageView?.image = UIImage(named: MenuOptions.allCases[indexPath.row].imageName)
//        cell.contentView.backgroundColor = UIColor.blueCustom()
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedItem = menuItems[indexPath.row]
        delegate?.didSelectMenuItem(name: selectedItem)
    }
    
    
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TableHeader.identifier)
//        return header
//    }
//
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 100
//    }
//
//    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: TableFooter.identifier)
//        return footer
//    }
//
//    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 200
//    }
}

