//
//  DetailCustomerViewController.swift
//  ADMIN_ECOMMERCE
//
//  Created by Sang Hi Bùi on 31/07/2022.
//

import UIKit
import DropDown

class DetailCustomerViewController: UIViewController {

    @IBOutlet weak var viewOfImage: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var dateOfBirthLabel: UILabel!
    @IBOutlet weak var placeOfBirthLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var createAtLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var dropDownRole: UIView!
    
    var customerID: String = ""
    
    var role = DropDown()
    let roleValues: [String] = ["user", "admin"]
    var roleTemp: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDetailCustomer()
        setupView()
        setupDropDown()
        setupRole()
    }
    
    func convertImageToBase64String (img: UIImage) -> String {
        let imageData:NSData = img.jpegData(compressionQuality: 0.50)! as NSData //UIImagePNGRepresentation(img)
        let imgString = imageData.base64EncodedString(options: .init(rawValue: 0))
        return imgString
    }
    
    private func setupRole() {
        role.anchorView = dropDownRole
        role.dataSource = roleValues
        role.bottomOffset = CGPoint(x: 0, y:(role.anchorView?.plainView.bounds.height)! + 5)
        role.direction = .top
       
        role.selectionAction = { [unowned self] (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
            guard let image = imageView.image else { return }
            self.roleLabel.text = item
            self.updateRole(imgString: convertImageToBase64String(img: image), name: nameLabel.text ?? "", birthday: dateOfBirthLabel.text ?? "", address: placeOfBirthLabel.text ?? "" , phone: phoneNumberLabel.text ?? "", email: emailLabel.text ?? "", customerID: customerID, role: item)
        }
        
        let gestureRole = UITapGestureRecognizer(target: self, action: #selector(didTapRole))
        dropDownRole.addGestureRecognizer(gestureRole)
        
    }
    
    @objc private func didTapRole() {
        role.show()
    }
    
    private func setupDropDown() {
        DropDown.appearance().textColor = UIColor.black
        DropDown.appearance().selectedTextColor = UIColor.black
        DropDown.appearance().textFont = UIFont.systemFont(ofSize: 15)
        DropDown.appearance().backgroundColor = UIColor.white
        DropDown.appearance().selectionBackgroundColor = UIColor.systemGreen
        DropDown.appearance().cornerRadius = 8
    }
    
    private func setupView() {
        viewOfImage.layer.cornerRadius = viewOfImage.frame.height/2
        imageView.layer.cornerRadius = viewOfImage.frame.height/2
        viewOfImage.layer.masksToBounds = true
    }
    
    func configData(customer: Info) {
        imageView.sd_setImage(with: URL(string: customer.avatar?.url ?? ""), placeholderImage: UIImage(named: "imageNull"))
        nameLabel.text = customer.name
        emailLabel.text = customer.emailUser
        
        if customer.placeOfBirth == "" {
            placeOfBirthLabel.text = "Not have place of birth"
        } else {
            placeOfBirthLabel.text = customer.placeOfBirth
        }
        
        if customer.dateOfBirth == "" {
            dateOfBirthLabel.text = "Not have date of birth"
        } else {
            dateOfBirthLabel.text = customer.dateOfBirth
        }
        
        if customer.phoneNumber == "" {
            phoneNumberLabel.text = "Not have phone number"
        } else {
            phoneNumberLabel.text = customer.phoneNumber
        }
        
       
        guard let createAt = customer.createAt else { return }
        let index = createAt.index(createAt.startIndex, offsetBy: 10)
        createAtLabel.text = String(createAt.prefix(upTo: index))
        roleLabel.text = customer.role
    }
    
}

extension DetailCustomerViewController {
    private func getDetailCustomer() {
        APIService.detailCustomer(customerID: customerID) { infoUser, error in
            guard let customer = infoUser?.user else { return }
            DispatchQueue.main.async {
                self.configData(customer: customer)
            }
            print(customer)
        }
    }
    
    private func updateRole(imgString: String, name: String, birthday: String, address: String, phone: String, email: String, customerID: String, role: String) {
        APIService.updateRole(imgString: imgString, name: name, birthday: birthday, address: address, phone: phone, email: email, customerID: customerID, role: role) { [weak self] res, error in
            guard let self = self else { return }
            guard let message = res?.success else {
                return
            }
            
            if message == true {
                let alert = UIAlertController(title: "Update role success", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            }
        }
    }
}
