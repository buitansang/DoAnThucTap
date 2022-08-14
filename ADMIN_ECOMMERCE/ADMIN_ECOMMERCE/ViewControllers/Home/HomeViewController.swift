//
//  HomeViewController.swift
//  ADMIN_ECOMMERCE
//
//  Created by Sang Hi Bùi on 24/07/2022.
//

import UIKit
import SideMenu
import SDWebImage


class HomeViewController: UIViewController {

    //MARK: - Outlets
    
    @IBOutlet weak var viewOfImage: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var dateOfBirthLabel: UILabel!
    @IBOutlet weak var placeOfBirthLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var createAtLabel: UILabel!
    
    //MARK: - Properties
    private var sideMenu: SideMenuNavigationController?
    var infoUser: InfoUser?
    
    //MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getProfile()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        setupSideMenu()
        setupView()
        
    }
    
    func formatDate(date: String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd-MM-yyyy"
        
        guard let dateAfter: Date? = dateFormatterGet.date(from: date) else { return ""}
        
        return dateFormatterPrint.string(from: dateAfter!)
    }

    private func setupView() {
        viewOfImage.layer.cornerRadius = viewOfImage.frame.height/2
        imageView.layer.cornerRadius = viewOfImage.frame.height/2
        viewOfImage.layer.masksToBounds = true
    }

    private func setupSideMenu() {
        let menu = MenuController(with: [MenuController.MenuOptions.products.rawValue,
                                         MenuController.MenuOptions.orders.rawValue,
                                         MenuController.MenuOptions.customers.rawValue,
                                         MenuController.MenuOptions.analytics.rawValue,
                                         MenuController.MenuOptions.logout.rawValue])
        menu.delegate = self
        sideMenu = SideMenuNavigationController(rootViewController: menu)
        sideMenu?.leftSide = true
        
        SideMenuManager.default.leftMenuNavigationController = sideMenu
        SideMenuManager.default.addPanGestureToPresent(toView: view)
    }
    
    @IBAction func didTapMenu() {
        guard let sideMenu = sideMenu else {
            return
        }
        present(sideMenu, animated: true)
    }
    
    @IBAction func didTapEditProfile() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let editVC = sb.instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
        editVC.infoUser = infoUser
        self.navigationController?.pushViewController(editVC, animated: true)
    }
}

extension HomeViewController: MenuControllerDelegate {
    func didSelectMenuItem(name: String) {
  
        sideMenu?.dismiss(animated: true, completion: { [weak self] in
            guard let self = self else { return }
            if name == MenuController.MenuOptions.products.rawValue {
                let sb = UIStoryboard(name: "Main", bundle: nil)
                guard let listProductVC = sb.instantiateViewController(withIdentifier: "ListProductViewController") as? ListProductViewController else { return }
                self.navigationController?.pushViewController(listProductVC, animated: true)
                
            } else if name == MenuController.MenuOptions.orders.rawValue {
              let sb = UIStoryboard(name: "Main", bundle: nil)
                guard let listOrderVC = sb.instantiateViewController(withIdentifier: "ListOrderViewController") as? ListOrderViewController else { return }
                self.navigationController?.pushViewController(listOrderVC, animated: true)
            } else if name == MenuController.MenuOptions.customers.rawValue {
                let sb = UIStoryboard(name: "Main", bundle: nil)
                guard let listCustomerVC = sb.instantiateViewController(withIdentifier: "ListCustomerViewController") as? ListCustomerViewController else { return }
                self.navigationController?.pushViewController(listCustomerVC, animated: true)
            } else if name == MenuController.MenuOptions.analytics.rawValue {
                
            }  else {
                let alert = UIAlertController(title: "", message: "Are you sure you want to log out?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    let sb = UIStoryboard(name: "Main", bundle: nil)
                    let navVC = sb.instantiateViewController(withIdentifier: "LoginNavigationController")
                    (UIApplication.shared.delegate! as! AppDelegate).setRootViewController(navVC)
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true)
            }
        })
    }
}

extension HomeViewController {
    private func getProfile() {
        APIService.getInfoUser { info, error in
            guard let info = info else {
                return
            }
            self.infoUser = info
            DispatchQueue.main.async {
                self.imageView.sd_setImage(with: URL(string: info.user?.avatar?.url ?? ""), placeholderImage: UIImage(named: "imageNull"))
                self.nameLabel.text = info.user?.name
                self.emailLabel.text = info.user?.emailUser
                self.placeOfBirthLabel.text = info.user?.placeOfBirth
                self.dateOfBirthLabel.text = self.formatDate(date: info.user?.dateOfBirth ?? "")
                
                self.phoneNumberLabel.text = info.user?.phoneNumber
                guard let createAt = info.user?.createAt else { return }
                let index = createAt.index(createAt.startIndex, offsetBy: 10)
                self.createAtLabel.text = self.formatDate(date: String(createAt.prefix(upTo: index)))
            }
        }
    }
}
