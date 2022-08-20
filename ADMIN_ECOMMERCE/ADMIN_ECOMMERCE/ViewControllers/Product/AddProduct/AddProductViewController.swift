//
//  AddProductViewController.swift
//  ADMIN_ECOMMERCE
//
//  Created by Sang Hi Bùi on 30/07/2022.
//

import UIKit
import DropDown
import Alamofire
import NVActivityIndicatorView

class AddProductViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var chooseButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var viewOfImage: UIView!
    @IBOutlet weak var imageProduct: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var nameItemOfClassify: UILabel!
    @IBOutlet weak var dropDownCategory: UIView!
    @IBOutlet weak var nameItemOfCategory: UILabel!
    @IBOutlet weak var dropDownClassify: UIView!
    
    let loading = NVActivityIndicatorView(frame: .zero, type: .lineSpinFadeLoader, color: .white, padding: 0)
    private let viewAnimate: UIView = {
        let view = UIView()
        view.frame = .zero
        view.backgroundColor = .lightGray
        return view
    }()
    
    var classify = DropDown()
    var category = DropDown()
    let classifyValues: [String] = ["Men", "Women", "Kid"]
    let categoryValues: [String] = ["Jackets & Coats", "Hoodies & Sweatshirts", "Cardigan & Jumpers", "T-shirt & Tanks", "Shoes", "Shirts", "Basics", "Blazers & Suits", "Shorts", "Trousers", "Jeans", "Swimwear", "Underwear", "Socks"]
    var classifyTemp: String = ""
    var categoryTemp: String = ""
    
    let imagePickerController = UIImagePickerController()
    var imgString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupKeyboard()
        tapOnView()
        addDoneButtonOnKeyboard()
        setupClassify()
        setupCategory()
        setupDropDown()
        imagePickerController.delegate = self
        
        
//        guard let iamge = UIImage(named: "imageNull") else { return }
//        let imgString = convertImageToBase64String(img: iamge)
//
//
//        APIService.addNewProduct(price: 10, name: "SangBuiTest", description: "Mo ta", classify: "Men", category: "jacketsCoats", stock: 999 , imgString: imgString) { add, aee in
//
//        }
    }
    
    private func setupViewAnimate() {
        viewAnimate.isHidden = true
        viewAnimate.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewAnimate)
        NSLayoutConstraint.activate([
            viewAnimate.widthAnchor.constraint(equalToConstant: 70),
            viewAnimate.heightAnchor.constraint(equalToConstant: 70),
            viewAnimate.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewAnimate.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupAnimation() {
        loading.translatesAutoresizingMaskIntoConstraints = false
        viewAnimate.addSubview(loading)
        NSLayoutConstraint.activate([
            loading.widthAnchor.constraint(equalToConstant: 30),
            loading.heightAnchor.constraint(equalToConstant: 30),
            loading.centerXAnchor.constraint(equalTo: viewAnimate.centerXAnchor),
            loading.centerYAnchor.constraint(equalTo: viewAnimate.centerYAnchor)
        ])
        loading.startAnimating()
    }
    
    
    private func setupDropDown() {
        DropDown.appearance().textColor = UIColor.black
        DropDown.appearance().selectedTextColor = UIColor.black
        DropDown.appearance().textFont = UIFont.systemFont(ofSize: 15)
        DropDown.appearance().backgroundColor = UIColor.white
        DropDown.appearance().selectionBackgroundColor = UIColor.systemGreen
        DropDown.appearance().cornerRadius = 8
    }
    
    private func tapOnView() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnView))
        view.addGestureRecognizer(gesture)
    }
    
    private func setupClassify() {
        nameItemOfClassify.text = "Classify"
        classify.anchorView = dropDownClassify
        classify.dataSource = classifyValues
        classify.bottomOffset = CGPoint(x: 0, y:(classify.anchorView?.plainView.bounds.height)! + 5)
        classify.direction = .top
        /*  public func dynamicChange(height toValue: CGFloat) {
        tableView.rowHeight = toValue
         } */
     //   classify.dynamicChange(height: 30)
        classify.selectionAction = { [unowned self] (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
            self.nameItemOfClassify.text = item
            if item == "Classify" {
                classifyTemp = ""
            } else {
                classifyTemp = item
            }
            print("Clasify now \(self.classifyTemp)")
        }
        
        let gestureClassify = UITapGestureRecognizer(target: self, action: #selector(didTapClassify))
        dropDownClassify.addGestureRecognizer(gestureClassify)
        //dropDownClassify.layer.borderWidth = 1
       // dropDownClassify.layer.borderColor = UIColor.systemGreen.cgColor
        
    }
    
    private func setupCategory() {
        nameItemOfCategory.text = "Category"
        category.anchorView = dropDownCategory
        category.dataSource = categoryValues
        category.bottomOffset = CGPoint(x: 0, y:(category.anchorView?.plainView.bounds.height)! + 5)
        category.direction = .top
        category.selectionAction = { [unowned self] (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
            self.nameItemOfCategory.text = item
            if item == "Category" {
                categoryTemp = ""
            }
            if item == "Jackets & Coats" {
                categoryTemp = "jacketsCoats"
            }
            if item == "Hoodies & Sweatshirts" {
                categoryTemp = "hoodiesSweatshirts"
            }
            if item == "Cardigan & Jumpers" {
                categoryTemp = "cardiganJumpers"
            }
            if item == "T-shirt & Tanks" {
                categoryTemp = "tshirtTanks"
            }
            if item == "Shoes" {
                categoryTemp = "shoes"
            }
            if item == "Shirts" {
                categoryTemp = "shirts"
            }
            if item == "Basics" {
                categoryTemp = "basics"
            }
            if item == "Blazers & Suits" {
                categoryTemp = "blazersSuits"
            }
            if item == "Shorts" {
                categoryTemp = "shorts"
            }
            if item == "Trousers" {
                categoryTemp = "trousers"
            }
            if item == "Jeans" {
                categoryTemp = "jeans"
            }
            if item == "Swimwear" {
                categoryTemp = "swimwear"
            }
            if item == "Underwear" {
                categoryTemp = "underwear"
            }
            if item == "Socks" {
                categoryTemp = "socks"
            }
        }
        
        let gestureCategory = UITapGestureRecognizer(target: self, action: #selector(didTapCategory))
        dropDownCategory.addGestureRecognizer(gestureCategory)

    }
    
    @objc func didTapClassify() {
        classify.show()
    }
    
    @objc func didTapCategory() {
        category.show()
    }
    
    
    @objc private func didTapOnView() {
        view.endEditing(true)
    }
    private func setupKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification:NSNotification) {

        guard let userInfo = notification.userInfo else { return }
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 100
        scrollView.contentInset = contentInset
    }

    @objc func keyboardWillHide(notification:NSNotification) {

        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
    
    private func setupView() {
        
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.borderColor = UIColor.black.cgColor
        imageProduct.image = UIImage(named: "imageNull")
        chooseButton.layer.cornerRadius = 12
        saveButton.layer.cornerRadius = 12
        viewOfImage.layer.cornerRadius = 12
        imageProduct.layer.cornerRadius = 12
        viewOfImage.layer.masksToBounds = true
        
        priceTextField.keyboardType = .numberPad
        quantityTextField.keyboardType = .numberPad
    }
    
    private func validateImage() -> Bool {
        if imageProduct.image == UIImage(named: "imageNull") {
            return false
        }
        return true
    }
    
    private func validatePrice() -> Bool {
        guard let price = priceTextField.text else { return false }
        if (Int(price) ?? 0) <= 0  || price.count <= 0 {
            return false
        }
        return true
    }
    
    private func validateQuantity() -> Bool {
        guard let quantity = quantityTextField.text else { return false }
        if (Int(quantity) ?? 0) <= 0 || quantity.count <= 0 {
            return false
        }
        return true
    }
    
    private func validateName() -> Bool {
        guard let name = nameTextField.text else {
            return false
        }
        
        if name.count <= 0 {
             return false
        }
        return true
    }
    
    private func validateDes() -> Bool {
        guard let des = descriptionTextView.text else {
            return false
        }
        
        if des.count <= 0 {
             return false
        }
        return true
    }
    
    func convertImageToBase64String (img: UIImage) -> String {
        let imageData:NSData = img.jpegData(compressionQuality: 0.50)! as NSData //UIImagePNGRepresentation(img)
        let imgString = imageData.base64EncodedString(options: .init(rawValue: 0))
        return imgString
    }
    
    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        nameTextField.inputAccessoryView = doneToolbar
        priceTextField.inputAccessoryView = doneToolbar
        quantityTextField.inputAccessoryView = doneToolbar
        descriptionTextView.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction(){
        view.endEditing(true)
    }
    
    @IBAction func didTapChooseButton() {
        let alert = UIAlertController(title: "Choose Product Image", message: "Choose the way", preferredStyle: .actionSheet)
        let actionPhoto = UIAlertAction(title: "Photo", style: .default) { (action) in
            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true, completion: nil)
        }
        let actionCamera = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.imagePickerController.sourceType = .camera
            self.present(self.imagePickerController, animated: true, completion: nil)
        }
        let actionCencal = UIAlertAction(title: "Cencal", style: .cancel) { (action) in
            
        }
        alert.addAction(actionPhoto)
        alert.addAction(actionCamera)
        alert.addAction(actionCencal)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func didTapSaveButton() {
        if validateImage() == true {
            print("trueImage")
            if validateName() == true {
                print("trueName")
                
                if validatePrice() == true {
                    print("truePrice")
            
                    if  validateQuantity() == true {
                        print("trueQuantity")
                        if validateDes() == true {
                            print("trueDes")
                            if !(categoryTemp == "")  {
                                if !(classifyTemp == "") {
                                    guard let price = priceTextField.text,
                                          let quantity = quantityTextField.text,
                                          let name = nameTextField.text,
                                          let des = descriptionTextView.text else { return }
    
                                    
                                    addProduct(price: Double(price) ?? 0.0 , name: name, description: des ?? "", classify: classifyTemp, category: categoryTemp, stock: Int(quantity) ?? 0, imgString: imgString)
                                    
                                } else {
                                    let alert = UIAlertController(title: "Please input product classify", message: "", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                                       
                                    }))
                                    present(alert, animated: true)
                                }
                            } else {
                                let alert = UIAlertController(title: "Please input product category", message: "", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                                   
                                }))
                                present(alert, animated: true)
                            }
                            
                        } else {
                            let alert = UIAlertController(title: "Please input product desciption", message: "", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                                self.descriptionTextView.becomeFirstResponder()
                            }))
                            present(alert, animated: true)
                        }
                    } else {
                        let alert = UIAlertController(title: "Please input product quantity", message: "", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                            self.quantityTextField.becomeFirstResponder()
                        }))
                        present(alert, animated: true)
                    }
                } else {
                    let alert = UIAlertController(title: "Please input product price", message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                        self.priceTextField.becomeFirstResponder()
                    }))
                    present(alert, animated: true)
                }
            } else {
                let alert = UIAlertController(title: "Please input product name", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    self.nameTextField.becomeFirstResponder()
                }))
                present(alert, animated: true)
            }
        }
        else {
            let alert = UIAlertController(title: "Please choose product image", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                
            }))
            present(alert, animated: true)
        }
    }
}

extension AddProductViewController: UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image: UIImage = info[.originalImage] as? UIImage {
            imageProduct.image = image
            imgString = convertImageToBase64String(img: image)
            imagePickerController.dismiss(animated: true, completion: nil)
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePickerController.dismiss(animated: true, completion: nil)
    }
}

extension AddProductViewController {
    
    private func addProduct(price: Double, name: String, description: String, classify: String, category: String, stock: Int , imgString: String) {
        viewAnimate.isHidden = false
        APIService.addNewProduct(price: price, name: name, description: description, classify: classify, category: category, stock: stock, imgString: imgString) { [weak self] product, error in
            self?.viewAnimate.isHidden = true
            guard let self = self else { return }
            
            guard let product = product else {
                let alert = UIAlertController(title: "Failure", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
                return
            }
            
            let alert = UIAlertController(title: "Success", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true)
        }
    }
}

