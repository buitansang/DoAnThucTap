//
//  AddDiscountViewController.swift
//  ADMIN_ECOMMERCE
//
//  Created by Sang Hi Bùi on 20/08/2022.
//

import UIKit
import DropDown
import NVActivityIndicatorView

class AddDiscountViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var valueTextField: UITextField!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var validDateTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var dropDownCategory: UIView!
    @IBOutlet weak var nameItemOfCategory: UILabel!
    
    var category = DropDown()
    let categoryValues: [String] = ["Jackets & Coats", "Hoodies & Sweatshirts", "Cardigan & Jumpers", "T-shirt & Tanks", "Shoes", "Shirts", "Basics", "Blazers & Suits", "Shorts", "Trousers", "Jeans", "Swimwear", "Underwear", "Socks"]
    var categoryTemp: String = ""
    let datePicker = UIDatePicker()
    
    let loading = NVActivityIndicatorView(frame: .zero, type: .lineSpinFadeLoader, color: .white, padding: 0)
    private let viewAnimate: UIView = {
        let view = UIView()
        view.frame = .zero
        view.backgroundColor = .lightGray
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextField()
        connerLayer()
        setupGesture()
        setupDropDown()
        setupCategory()
        createToolbar()
        if #available(iOS 13.4, *) {
            createDatePicker()
        } else {
            // Fallback on earlier versions
        }
        setupViewAnimate()
        setupAnimation()
        
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
    
    @available(iOS 13.4, *)
    private func createDatePicker() {
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        validDateTextField.inputView = datePicker
        validDateTextField.inputAccessoryView = createToolbar()
    }
    
    private func createToolbar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: true)
        return toolbar
    }
    
    private func setupDropDown() {
        DropDown.appearance().textColor = UIColor.black
        DropDown.appearance().selectedTextColor = UIColor.black
        DropDown.appearance().textFont = UIFont.systemFont(ofSize: 15)
        DropDown.appearance().backgroundColor = UIColor.white
        DropDown.appearance().selectionBackgroundColor = UIColor.systemGreen
        DropDown.appearance().cornerRadius = 8
    }
    
    @objc func donePressed() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-YYYY"
        validDateTextField.text =  dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
    }
    
    func currentTimeInMiliseconds(date: Date) -> Int {
        let since1970 = date.timeIntervalSince1970
        return Int(since1970 * 1000)
    }
    
    private func setupCategory() {
        nameItemOfCategory.text = "Category"
        category.anchorView = dropDownCategory
        category.dataSource = categoryValues
        category.bottomOffset = CGPoint(x: 0, y:(category.anchorView?.plainView.bounds.height)! + 5)
        category.direction = .bottom
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
    
    @objc func didTapCategory() {
        category.show()
    }

    private func setupGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapOnView))
        view.addGestureRecognizer(gesture)
    }
    
    @objc private func tapOnView() {
        view.endEditing(true)
    }
    
    private func connerLayer() {
        saveButton.layer.cornerRadius = 12
    }
    
    private func setupTextField() {
        valueTextField.keyboardType = .numberPad
        quantityTextField.keyboardType = .numberPad
    }
    
    private func validateText() -> Bool {
        let name = nameTextField.text ?? ""
        if name == "" {
            let alert = UIAlertController(title: "Name is empty", message: "Fill name discount", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
                self.nameTextField.becomeFirstResponder()
            }))
            present(alert, animated: true)
            return  false
        }
        let value = valueTextField.text ?? "0"
        let valueInt = Int(value) ?? 0
        if valueInt <= 0 || valueInt > 100 {
            let alert = UIAlertController(title: "Value is not zero and less than 100", message: "Fill value discount", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
                self.valueTextField.becomeFirstResponder()
            }))
            present(alert, animated: true)
            return false
        }
        let quantity = quantityTextField.text ?? "0"
        let quantityInt = Int(quantity) ?? 0
        if quantityInt <= 0 {
            let alert = UIAlertController(title: "Quantity is not zero", message: "Fill quantity discount", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
                self.quantityTextField.becomeFirstResponder()
            }))
            present(alert, animated: true)
            return false
        }
        
        if nameItemOfCategory.text == "Category" {
            let alert = UIAlertController(title: "Category is not filled", message: "Fill category ", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
                self.quantityTextField.resignFirstResponder()
            }))
            present(alert, animated: true)
            return false
        }
        
        if validDateTextField.text == "" {
            let alert = UIAlertController(title: "Valid date is not filled", message: "Fill valid date ", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
            }))
            present(alert, animated: true)
            return false
        }
        
        return true
    }
    
    @IBAction func didTapSaveButton() {
        if validateText() {
            let quantity = quantityTextField.text ?? "0"
            let quantityInt = Int(quantity) ?? 0
            let value = valueTextField.text ?? "0"
            let valueInt = Int(value) ?? 0
            let validDateDouble = Double(currentTimeInMiliseconds(date: datePicker.date))
            addNew(name: nameTextField.text ?? "", quantity: quantityInt, categoryProduct: categoryTemp, validDate: validDateDouble, value: valueInt)
        } 
    }
    
}

extension AddDiscountViewController {
    private func addNew(name: String, quantity: Int, categoryProduct: String, validDate: Double, value: Int) {
    
        viewAnimate.isHidden = false
        APIService.createDiscount(name: name, quantity: quantity, categoryProduct: categoryProduct, validDate: validDate, value: value) { res, error in
            self.viewAnimate.isHidden = true
            guard let res = res else {
                let alert = UIAlertController(title: "Fail", message: "Try again", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
                }))
                self.present(alert, animated: true)
                return
            }
            
            let alert = UIAlertController(title: "Sussess", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
                self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true)
            return
        }
    }
}
