//
//  ListCustomerTableViewCell.swift
//  ADMIN_ECOMMERCE
//
//  Created by Sang Hi Bùi on 31/07/2022.
//

import UIKit
import SDWebImage

class ListCustomerTableViewCell: UITableViewCell {

    @IBOutlet weak var viewOfImage: UIView!
    @IBOutlet weak var imageCustomer: UIImageView!
    @IBOutlet weak var nameCustomer: UILabel!
    @IBOutlet weak var phoneNumberCustomer: UILabel!
    @IBOutlet weak var emailCustomer: UILabel!
    @IBOutlet weak var creatAtCustomer: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupView() {
        selectionStyle = .none
        separatorInset = UIEdgeInsets(top: 0, left: 143, bottom: 0, right: 0)
        imageCustomer.layer.cornerRadius = 10
        viewOfImage.layer.cornerRadius = 10
        viewOfImage.layer.shadowRadius = 8
        viewOfImage.layer.shadowOpacity = 0.2
        viewOfImage.layer.shadowOffset =  CGSize(width: 1 , height: 3)
        viewOfImage.layer.masksToBounds = false
        
    }
    
    func bind(customer: Customer) {
        imageCustomer.sd_setImage(with: URL(string: customer.avatar?.url ?? ""), placeholderImage: UIImage(named: "imageNull"))
        nameCustomer.text = customer.name
        if customer.phoneNumber == "" {
            phoneNumberCustomer.text = "Not have phone number"
        } else {
            phoneNumberCustomer.text = customer.phoneNumber
        }
        
        emailCustomer.text = customer.emailUser
        creatAtCustomer.text = "Creat At: " + formatDate(date: customer.createAt ?? "")
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
