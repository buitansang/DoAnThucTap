//
//  ListDiscountTableViewCell.swift
//  ADMIN_ECOMMERCE
//
//  Created by Sang Hi Bùi on 19/08/2022.
//

import UIKit

class ListDiscountTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameDiscount: UILabel!
    @IBOutlet weak var valueDiscount: UILabel!
    @IBOutlet weak var quantityDiscount: UILabel!
    @IBOutlet weak var categoryDiscount: UILabel!
    @IBOutlet weak var createAtDiscount: UILabel!
    @IBOutlet weak var validDateDiscount: UILabel!
    @IBOutlet weak var sttDiscount: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func binding(discount: DiscountItem, indexPath: IndexPath) {
        sttDiscount.text = "DISCOUNT " + String(indexPath.row + 1)
        nameDiscount.text = discount.name
        let value = discount.value ?? 0
        valueDiscount.text = String(value)
        let quantity = discount.quantity ?? 0
        quantityDiscount.text = String(quantity)
        categoryDiscount.text = discount.categoryProduct
        let createAt = discount.createAt ?? ""
        createAtDiscount.text = formatDate(date: createAt)
        let validDate = discount.validDate ?? ""
        validDateDiscount.text = formatDate(date: validDate)

    }
    
    func formatDate(date: String) -> String {
       let dateFormatterGet = DateFormatter()
       dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
   
       let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd-MM-yyyy HH:mm"

       let dateAfter: Date? = dateFormatterGet.date(from: date)

       return dateFormatterPrint.string(from: dateAfter!)
    }
}
