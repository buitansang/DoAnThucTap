//
//  ListOrderTableViewCell.swift
//  ADMIN_ECOMMERCE
//
//  Created by Sang Hi Bùi on 31/07/2022.
//

import UIKit

class ListOrderTableViewCell: UITableViewCell {

    @IBOutlet weak var orderIDLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var createAtLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bind(order: Order) {
        orderIDLabel.text = order._id
        if let price = order.totalPrice {
            let priceInt = Int(price)
            totalPriceLabel.text = "$ " + String(priceInt)
        }
        statusLabel.text = order.orderStatus
        
        createAtLabel.text = formatDate(date: order.createAt ?? "")
    }
    
    func formatDate(date: String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd-MM-yyyy HH:mm"
        
        guard let dateAfter: Date? = dateFormatterGet.date(from: date) else { return ""}
        
        return dateFormatterPrint.string(from: dateAfter!)
    }
    
}
