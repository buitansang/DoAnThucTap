//
//  EditProfileViewController.swift
//  ADMIN_ECOMMERCE
//
//  Created by Sang Hi Bùi on 24/07/2022.
//

import UIKit
import NVActivityIndicatorView

class EditProfileViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewOfImage: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    @IBOutlet weak var placeOfBirthTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var createAtLabel: UILabel!
    @IBOutlet weak var updateButton: UIButton!
    
    var infoUser: InfoUser?
    
    let imagePickerController = UIImagePickerController()
    let datePicker = UIDatePicker()
    var selectImage = UIImage()
    var imgString: String = ""
    var checkUpdate: Bool?
    
    let loading = NVActivityIndicatorView(frame: .zero, type: .lineSpinFadeLoader, color: .white, padding: 0)
    private let viewAnimate: UIView = {
        let view = UIView()
        view.frame = .zero
        view.backgroundColor = .lightGray
        return view
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateButton.isEnabled = true
        viewAnimate.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        view.addSubview(viewAnimate)
        imagePickerController.delegate = self
        tapOnView()
        setupKeyboard()
        setupViewAnimate()
        setupAnimation()
        if #available(iOS 13.4, *) {
            createDatePicker()
        } else {
            // Fallback on earlier versions
        }
        
    }
    

    private func setupView() {
        viewOfImage.layer.cornerRadius = viewOfImage.frame.height/2
        imageView.layer.cornerRadius = viewOfImage.frame.height/2
       // viewOfImage.layer.masksToBounds = true
        updateButton.layer.cornerRadius = 12
        DispatchQueue.main.async {
            self.imageView.sd_setImage(with: URL(string: self.infoUser?.user?.avatar?.url ?? ""), placeholderImage: UIImage(named: "imageNull"))
            self.nameTextField.text = self.infoUser?.user?.name
            self.emailTextField.text = self.infoUser?.user?.emailUser
            self.placeOfBirthTextField.text = self.infoUser?.user?.placeOfBirth
            self.dateOfBirthTextField.text = self.infoUser?.user?.dateOfBirth
            
            guard var  phoneNumber84 = self.infoUser?.user?.phoneNumber else { return }
            phoneNumber84.remove(at: phoneNumber84.startIndex)
            phoneNumber84.remove(at: phoneNumber84.startIndex)
            phoneNumber84.remove(at: phoneNumber84.startIndex)
            let phoneNumber0 = "0" + phoneNumber84
            self.phoneNumberTextField.text = phoneNumber0
            guard let createAt = self.infoUser?.user?.createAt else { return }
            let index = createAt.index(createAt.startIndex, offsetBy: 10)
            self.createAtLabel.text = String(createAt.prefix(upTo: index))
        }
    }
    
    private func tapOnView() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnScreen))
        self.view.addGestureRecognizer(gesture)
    }
    
    private func setupKeyboard() {
        phoneNumberTextField.keyboardType = .numberPad
        emailTextField.keyboardType = .emailAddress
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupViewAnimate() {
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
    
    func convertImageToBase64String (img: UIImage) -> String {
        let imageData:NSData = img.jpegData(compressionQuality: 0.50)! as NSData //UIImagePNGRepresentation(img)
        let imgString = imageData.base64EncodedString(options: .init(rawValue: 0))
        return imgString
    }
    
    @available(iOS 13.4, *)
    private func createDatePicker() {
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        dateOfBirthTextField.inputView = datePicker
        dateOfBirthTextField.inputAccessoryView = createToolbar()
    }
    
    private func createToolbar() -> UIToolbar {
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //done button
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: true)
        
        return toolbar
    }
    
    func isValidPhone(phone: String) -> Bool {
        let phoneRegex = "[0]{1}+[0-9]{9}"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: phone)
    }
    
    private func isValidEmail(email: String) -> Bool {
        let emailPatterm = "\\w+@\\w+(\\.\\w+){1,2}"
        let emailFormat = NSPredicate(format:"SELF MATCHES %@", emailPatterm)
        return emailFormat.evaluate(with: email)
    }
    

    @objc func donePressed() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateOfBirthTextField.text =  dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
    }
    
    @objc func didTapOnScreen() {
        view.endEditing(true)
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
    
    @IBAction func didTapEditAvatar() {
        let alert = UIAlertController(title: "Update Avatar", message: "Choose the way", preferredStyle: .actionSheet)
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
    
    @IBAction func didTapUpdate() {
        var nameText = nameTextField.text ?? ""
        var  birthDayText = dateOfBirthTextField.text ?? ""
        var addressText = placeOfBirthTextField.text ?? ""
        var phoneText = phoneNumberTextField.text ?? ""
        var emailText = emailTextField.text ?? ""

       if nameText.count <= 0  {
           let alert = UIAlertController(title: "Name is empty !!", message: "input your name", preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
               self.nameTextField.becomeFirstResponder()
           }))
           self.present(alert, animated: true)
       } else if birthDayText.count <= 0 {
           let alert = UIAlertController(title: "Birthday is empty !!", message: "input your birthday", preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
               self.dateOfBirthTextField.becomeFirstResponder()
           }))
           self.present(alert, animated: true)
       } else if (Int(birthDayText.prefix(4)) ?? 0) >= 2022 {
           let alert = UIAlertController(title: "Birthday is not valid !!", message: "input your birthday", preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
               self.dateOfBirthTextField.becomeFirstResponder()
           }))
           self.present(alert, animated: true)
       } else if addressText.count <= 0 {
           let alert = UIAlertController(title: "Address is empty !!", message: "input your address", preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
               self.placeOfBirthTextField.becomeFirstResponder()
           }))
           self.present(alert, animated: true)
       } else if !isValidPhone(phone: phoneText) {
           let alert = UIAlertController(title: "Phone is not valid !!", message: "input your phone again", preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
               self.phoneNumberTextField.becomeFirstResponder()
           }))
           self.present(alert, animated: true)
       } else if !isValidEmail(email: emailText) {
           let alert = UIAlertController(title: "Phone is not valid !!", message: "input your phone again", preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
               self.emailTextField.becomeFirstResponder()
           }))
           self.present(alert, animated: true)
       } else {
           updateButton.isEnabled = false
           putUpdateProfile()
       }
   
    }

}

extension EditProfileViewController: UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image: UIImage = info[.originalImage] as? UIImage {
            selectImage = image
            imageView.image = image
            self.imgString = convertImageToBase64String(img: selectImage)
            imagePickerController.dismiss(animated: true, completion: nil)
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePickerController.dismiss(animated: true, completion: nil)
    }
}

extension EditProfileViewController {
    //Call API put update profile
    private func putUpdateProfile() {
        viewAnimate.isHidden = false
        guard let imageAvatar = imageView.image else { return }
        imgString = convertImageToBase64String(img: imageAvatar)
        guard var phoneNumber84 = phoneNumberTextField.text else { return }
        phoneNumber84.remove(at: phoneNumber84.startIndex)
        phoneNumber84 = "+84" + phoneNumber84
        APIService.putUpdateProfile(imgString, nameTextField.text ?? "", dateOfBirthTextField.text ?? "", placeOfBirthTextField.text ?? "", phoneNumber84, emailTextField.text ?? "") { updateProfile, error in
            self.viewAnimate.isHidden = true
            guard let updateProfile = updateProfile else { return }
            print("UPDATE PROFILE: \(updateProfile)")
            guard let checkUpdate = updateProfile.success else { return }
            if checkUpdate == true {
                let alert = UIAlertController(title: "Update profile completely !", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cencal", style: .cancel, handler: { _ in
                    self.updateButton.isEnabled = true
                }))
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

