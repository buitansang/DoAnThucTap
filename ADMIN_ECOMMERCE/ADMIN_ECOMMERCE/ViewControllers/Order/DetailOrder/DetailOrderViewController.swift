//
//  DetailOrderViewController.swift
//  ADMIN_ECOMMERCE
//
//  Created by Sang Hi Bùi on 06/08/2022.
//

import UIKit

enum Status: String {
    case cancel = "Cancel"
    case procesing = "Processing"
    case confirmed = "Confirmed"
    case delivered = "Delivered"
    case complete = "Complete"
}

class DetailOrderViewController: UIViewController {
    
    @IBOutlet weak var itemOrderTableView: UITableView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var cancelOrder: UIButton!
    @IBOutlet weak var confirmOrder: UIButton!
    @IBOutlet weak var deilveredOrder: UIButton!
    
    var orderID: String = ""
    var order: OrderID?
    var itemsOrder: [OrderItem] = [] {
        didSet {
            itemOrderTableView.reloadData()
        }
    }
    
    private func resetButton() {
        cancelOrder.isHidden = true
        confirmOrder.isHidden = true
        deilveredOrder.isHidden = true
    }
    
    var status: String = "" {
        didSet {
            if status == Status.procesing.rawValue {
                resetButton()
                cancelOrder.isHidden = false
                confirmOrder.isHidden = false
            }
            
            if status == Status.confirmed.rawValue {
                resetButton()
                deilveredOrder.isHidden = false
            }
            
            if status == Status.delivered.rawValue {
                
            }
            
            if status == Status.complete.rawValue {
                
            }
            
            if status == Status.cancel.rawValue {
                
            }
                
        }
    }
    
    let totalPriceLabel = UILabel(frame: CGRect(x: 15, y: 90, width: 315, height: 30))
    let taxPrice = UILabel(frame: CGRect(x: 15, y: 60, width: 315, height: 30))
    let itemsPrice = UILabel(frame: CGRect(x: 15, y: 30, width: 315, height: 30))
    let shippingPrice = UILabel(frame: CGRect(x: 15, y: 0, width: 315, height: 30))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Order"
        getOrderByID(orderID: orderID)
        setupTableView()
        layerConner()

    }
    
    private func layerConner() {
        confirmOrder.layer.cornerRadius =  12
        cancelOrder.layer.cornerRadius =  12
        deilveredOrder.layer.cornerRadius =  12
    }
    
    private func bind(order: OrderID) {
        let space = "     "
     //   self.shippingPrice.text = "Shipping Price:                 2 $"
        guard let address = order.shippingInfo?.address else { return }
        self.addressLabel.text = "Address: " + space + address
        guard let city = order.shippingInfo?.city else { return }
        self.cityLabel.text = "City:       " + space + city
        guard let country = order.shippingInfo?.country else { return }
        self.countryLabel.text = "Country: " + space + country
        guard let phone = order.shippingInfo?.phoneNo else { return }
        self.phoneLabel.text = "Phone:   " + space + phone
    }
    
    private func setupFooterView(order: OrderID) {
        let space1 = "                "
        guard let totalPrice = order.totalPrice else { return }
        self.totalPriceLabel.text = "Total Price:       " + space1 + String(totalPrice) + " $"
        guard let taxPrice = order.taxPrice else { return }
        self.taxPrice.text = "Tax Price:          " + space1 + String(taxPrice) + " $"
        guard let itemsPrice = order.itemsPrice else { return }
        self.itemsPrice.text = "Items Price:       " + space1 + String(itemsPrice) + " $"
    }
    
    private func setupTableView() {
        itemOrderTableView.register(UINib(nibName: "DetailOrderTableViewCell", bundle: nil), forCellReuseIdentifier: "DetailOrderTableViewCell")
        // Footer
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 130))
        totalPriceLabel.textColor = .systemRed
        taxPrice.textColor = .black
        itemsPrice.textColor = .black
        shippingPrice.textColor = .black
        customView.backgroundColor = UIColor.white
        customView.addSubview(taxPrice)
        customView.addSubview(totalPriceLabel)
        customView.addSubview(itemsPrice)
        customView.addSubview(shippingPrice)
        itemOrderTableView.tableFooterView = customView
    }
    
    @IBAction func didTapCancel() {
        let alert = UIAlertController(title: "You want to cancel order", message: "You sure?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cencal", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.updateOrderStatus(with: Status.cancel.rawValue)
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true)
    }
    
    @IBAction func didTapConfirm() {
        updateOrderStatus(with: Status.confirmed.rawValue)
        self.navigationController?.popViewController(animated: true)

    }
    
    @IBAction func didTapdeilvered() {
        updateOrderStatus(with: Status.delivered.rawValue)
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension DetailOrderViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsOrder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = itemsOrder[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailOrderTableViewCell", for: indexPath) as? DetailOrderTableViewCell else { return UITableViewCell() }
        cell.bind(item: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}


extension DetailOrderViewController {
    private func getOrderByID(orderID: String) {
        APIService.getOrderByID(orderID: orderID) { [weak self] res, error in
            guard let self = self else { return }
            guard let res = res, let order = res.order else {
                return
            }
            self.order = order
            self.itemsOrder = order.orderItems
            self.status = order.orderStatus ?? ""
            print(self.status)
            DispatchQueue.main.async {
                self.bind(order: order)
                self.setupFooterView(order: order)
            }
        }
    }
    
    private func updateOrderStatus(with status: String) {
        APIService.updateOrderStatus(with: orderID, status) { detailOrder, error in
            guard let detailOrder = detailOrder else { return }
            print("updateStatus: \(detailOrder)")
        }
    }

}
