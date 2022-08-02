//
//  ReviewsTableViewCell.swift
//  ADMIN_ECOMMERCE
//
//  Created by Sang Hi Bùi on 30/07/2022.
//

import UIKit
import Cosmos

class ReviewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var viewOfAvatar: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var viewRating: CosmosView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        setupRatingView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)

    }
    
    private func setupUI() {
        avatar.layer.cornerRadius = 25
        viewOfAvatar.layer.cornerRadius = 25
        viewOfAvatar.layer.masksToBounds = false
    }
    
    private func setupRatingView() {
        viewRating.settings.totalStars = 5
        viewRating.settings.starSize = 20
        viewRating.settings.starMargin = 3
        viewRating.settings.fillMode = .precise
        viewRating.settings.updateOnTouch = false
    }
    
    func bind(comment: Comment) {
        viewRating.rating = comment.rating ?? 0.0
        name.text = comment.userName
        self.comment.text = comment.comment
        date.text = "Created At: " + formatDate(date: comment.createAt ?? "")
        avatar.sd_setImage(with: URL(string: comment.image ?? ""), placeholderImage: UIImage(named: "sang"))
  
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

