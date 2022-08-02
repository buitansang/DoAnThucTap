//
//  LoginViewController.swift
//  ADMIN_ECOMMERCE
//
//  Created by Sang Hi Bùi on 24/07/2022.
//

import UIKit
import NVActivityIndicatorView

class LoginViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailImgView: UIImageView!
    @IBOutlet weak var passwordImgView: UIImageView!
    
    //MARK: - Properties
    var checkLogin: Bool?
    //  var info: Info?
    let loading = NVActivityIndicatorView(frame: .zero, type: .lineSpinFadeLoader, color: .white, padding: 0)
    private let viewAnimate: UIView = {
        let view = UIView()
        view.frame = .zero
        view.backgroundColor = .lightGray
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 12
        setupTextField()
        setupKeyboard()
        tapOnView()
        setupViewAnimate()
        setupAnimation()
        emailTextField.text = "buitansang@yopmail.com"
        passwordTextField.text = "buitansang"
        
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
    
    private func setupTextField() {
        emailTextField.keyboardType = .emailAddress
        emailTextField.addTarget(self, action: #selector(emailTextFieldDidBegin(_:)), for: .editingDidBegin)
        
        emailTextField.addTarget(self, action: #selector(emailTextFieldDidEndEditing(_:)), for: .editingDidEnd)
        
        passwordTextField.addTarget(self, action: #selector(passwordTextFieldDidBegin(_:)), for: .editingDidBegin)
        
        passwordTextField.addTarget(self, action: #selector(passwordTextFieldDidEndEditing(_:)), for: .editingDidEnd)
    }
    
    private func setupKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func tapOnView() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnScreen))
        self.view.addGestureRecognizer(gesture)
    }
    
    @objc func didTapOnScreen() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification:NSNotification) {
        
        guard let userInfo = notification.userInfo else { return }
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 50
        scrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification:NSNotification) {
        
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
    
    @objc func emailTextFieldDidBegin(_ sender: UITextField) {
        emailTextField.textColor = .systemGreen
        emailTextField.tintColor = .systemGreen
        emailImgView.tintColor = UIColor.systemGreen
    }
    
    @objc func passwordTextFieldDidBegin(_ sender: UITextField) {
        passwordTextField.textColor = .systemGreen
        passwordTextField.tintColor = .systemGreen
        passwordImgView.tintColor = UIColor.systemGreen
    }
    
    @objc func emailTextFieldDidEndEditing(_ sender: UITextField) {
        emailTextField.textColor = .none
        emailTextField.tintColor = .none
        emailImgView.tintColor = .black
    }
    
    @objc func passwordTextFieldDidEndEditing(_ sender: UITextField) {
        passwordTextField.textColor = .none
        passwordTextField.tintColor = .none
        passwordImgView.tintColor = .black
    }
    
    //MARK: - Action
    
    @IBAction func didTapLogin(_ sender: UIButton) {
        view.endEditing(true)
        loginButton.isEnabled = false
        login()
    }
}

extension LoginViewController {
    //Call api login
    private func login() {
        viewAnimate.isHidden = false
        APIService.postLogin(email: emailTextField.text ?? "", password: passwordTextField.text ?? "") { accountUser, error in
            self.viewAnimate.isHidden = true
            guard let accountUser = accountUser else {
                let alert = UIAlertController(title: "Wrong email or password", message: "Please check and try again", preferredStyle: .alert)
                
                let actionCencal = UIAlertAction (title: "Cencal", style: .cancel) { (action) in
                    self.emailTextField.text = ""
                    self.passwordTextField.text = ""
                    self.emailTextField.becomeFirstResponder()
                    self.loginButton.isEnabled = true
                }
                alert.addAction(actionCencal)
                self.present(alert, animated: true, completion: nil)
                return
                
            }
            guard let token = accountUser.token else { return }
            guard let userID = accountUser.user?._id else { return }
            guard let role = accountUser.user?.role else { return }
            self.checkLogin = accountUser.success
            UserService.shared.setToken(with: token)
            UserService.shared.setUserID(with: userID)
            //   self.getInfoUser()
            if self.checkLogin == true && role == "admin" {
                self.viewAnimate.isHidden = true
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let navHome = sb.instantiateViewController(withIdentifier: "navHomeViewController")
                (UIApplication.shared.delegate! as! AppDelegate).setRootViewController(navHome, animated: true)
                
            } else {
                let alert = UIAlertController(title: "You are not ADMIN", message: "Please check and try again", preferredStyle: .alert)
                
                let actionCencal = UIAlertAction (title: "Cencal", style: .cancel) { (action) in
                    self.emailTextField.text = ""
                    self.passwordTextField.text = ""
                    self.emailTextField.becomeFirstResponder()
                    self.loginButton.isEnabled = true
                }
                alert.addAction(actionCencal)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}


