//
//  DetailProductViewController.swift
//  ADMIN_ECOMMERCE
//
//  Created by Sang Hi Bùi on 30/07/2022.
//

import UIKit
import Cosmos

class DetailProductViewController: UIViewController {

    @IBOutlet weak var imagePanel: UIImageView!
    @IBOutlet weak var nameProduct: UILabel!
    @IBOutlet weak var categoryProduct: UILabel!
    @IBOutlet weak var classifyProduct: UILabel!
    @IBOutlet weak var descriptionProduct: UILabel!
    @IBOutlet weak var ratingTableView: UITableView!
    @IBOutlet weak var ratingTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var priceProduct: UILabel!
    @IBOutlet weak var notHaveRating: UILabel!
    @IBOutlet weak var startRating: CosmosView!
    @IBOutlet weak var ratingPointLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    
    
    var productID: String = ""
    var listComment: [Comment] = []
    var product: Product?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getDetailProduct()
        getReviewComment()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRatingView()
        setupTableView()
        createBarButton()
    }
    
    private func createBarButton() {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "edit"), for: .normal)
        button.setTitle("Edit", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(didTapEdit), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 70, height: 51)
        button.imageEdgeInsets.left = -20
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        ratingTableViewHeight.constant = CGFloat(Double(listComment.count) * 120)
    }
    
    @objc private func didTapEdit() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        guard let editProductVC = sb.instantiateViewController(withIdentifier: "EditProductViewController") as? EditProductViewController else { return }
        editProductVC.product = product
        self.navigationController?.pushViewController(editProductVC, animated: true)
    }
    
    private func setupTableView() {
        ratingTableView.register(UINib(nibName: "ReviewsTableViewCell", bundle: nil), forCellReuseIdentifier: "ReviewsTableViewCell")
    }
    
    private func setupRatingLabel() {
        if listComment.isEmpty {
            // Show label
            notHaveRating.isHidden = false
            ratingTableView.isHidden = true
        }
        else {
            // Show table
            ratingTableView.reloadData()
            notHaveRating.isHidden = true
            ratingTableView.isHidden = false
        }
    }
    
    func setupRatingView() {
        startRating.settings.totalStars = 5
        startRating.settings.starSize = 20
        startRating.settings.starMargin = 3
        startRating.settings.fillMode = .precise
        startRating.settings.updateOnTouch = false
    }

    
    private func setupView(product: Product) {
        imagePanel.sd_setImage(with: URL(string: product.images?.first?.url ?? ""), placeholderImage: UIImage(named: "imageNull"))
        nameProduct.text = product.name?.uppercased()
        categoryProduct.text = product.category
        classifyProduct.text = product.classify
        if let price = product.price {
            let priceInt = Int(price)
            priceProduct.text = "$ " + String(priceInt)
        }
        descriptionProduct.text = "About: " + (product.description ?? "")
        stockLabel.text = String(product.stock ?? 0)
    }
    
}


extension DetailProductViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listComment.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let comment = listComment[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewsTableViewCell", for: indexPath) as! ReviewsTableViewCell
        cell.bind(comment: comment)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

extension DetailProductViewController {
    private func getDetailProduct() {
        APIService.getDetailProduct(with: productID ?? "") { detailProduct, error in
            guard let detailProduct = detailProduct, let product = detailProduct.product else {  return }
            print("Detail product: \(product)")
            self.product = product
            DispatchQueue.main.async {
                self.setupView(product: product)
            }
        }
    }
    private func getReviewComment() {
        APIService.getReviewComment(with: productID) { reviewComment, error in
            guard let reviewComment = reviewComment, let listComment = reviewComment.list, let averageReview = reviewComment.averageReview else { return }
            DispatchQueue.main.async {
                self.listComment = listComment
                self.ratingPointLabel.text =  String(averageReview) + " / 5"
                self.startRating.rating = averageReview
                self.ratingTableView.reloadData()
                self.setupRatingLabel()
            }
        }
    }
}
