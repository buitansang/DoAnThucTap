//
//  ListProductTableViewCell.swift
//  ADMIN_ECOMMERCE
//
//  Created by Sang Hi Bùi on 30/07/2022.
//

import UIKit

class ListProductTableViewCell: UITableViewCell {
    
    @IBOutlet weak var viewOfImageProduct: UIView!
    @IBOutlet weak var imageProduct: UIImageView!
    @IBOutlet weak var nameProduct: UILabel!
    @IBOutlet weak var desProduct: UILabel!
    @IBOutlet weak var priceProduct: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
    
    }
    
    func bind(product: Product) {
        imageProduct.sd_setImage(with: URL(string: product.images?.first?.url ?? ""), placeholderImage: UIImage(named: "imageNull"))
        nameProduct.text = product.name
        desProduct.text = product.description
        if let price = product.price {
            let priceInt = Int(price)
            priceProduct.text = "$ " + String(priceInt)
        }
    }
    
    
    func setupView() {
        separatorInset = UIEdgeInsets(top: 0, left: 143, bottom: 0, right: 0)
        imageProduct.layer.cornerRadius = 10
        viewOfImageProduct.layer.cornerRadius = 10
        viewOfImageProduct.layer.shadowRadius = 8
        viewOfImageProduct.layer.shadowOpacity = 0.3
        viewOfImageProduct.layer.shadowOffset =  CGSize(width: 1 , height: 3)
        viewOfImageProduct.layer.masksToBounds = false
    }
  }
