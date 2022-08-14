//
//  DetailOrderTableViewCell.swift
//  ADMIN_ECOMMERCE
//
//  Created by Sang Hi Bùi on 06/08/2022.
//

import UIKit
import SDWebImage

class DetailOrderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var viewOfImage: UIView!
    @IBOutlet weak var imageProduct: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupUI() {
        selectionStyle = .none
        imageProduct.layer.cornerRadius = 8
        viewOfImage.layer.cornerRadius = 8
        viewOfImage.layer.shadowRadius = 10
        viewOfImage.layer.shadowOpacity = 0.3
        viewOfImage.layer.shadowOffset =  CGSize(width: 1 , height: 3)
        viewOfImage.layer.masksToBounds = false
    }
    
    func bind(item: OrderItem) {
        imageProduct.sd_setImage(with: URL(string: item.image ?? ""), placeholderImage: UIImage(named: "imageNull"))
        nameLabel.text = item.name
        if let quantity = item.quantity {
            quantityLabel.text = "x " + String(quantity)
        }
        if let price = item.price {
            priceLabel.text = "Price: " + String(price) + " $"
        }
    }
    
}
