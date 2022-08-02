//
//  APIService.swift
//  ADMIN_ECOMMERCE
//
//  Created by Sang Hi Bùi on 24/07/2022.
//

import Foundation
import Alamofire

struct APIService {
    //Login
    static func postLogin(email email: String, password password: String, _ completion: @escaping(Account?, String?) -> ()) {
        let params: [String: Any ] = ["email": email, "password": password]
        APIController.request(Account.self, .login, params: params) { error, data in
            if let account = data {
                completion(account, nil)
                return
            }
            completion(nil, error)
            print("Lỗi postLogin")
        }
    }
    
    // Get Info User
    static func getInfoUser(_ completion: @escaping(InfoUser?, String?) -> ()) {
        let params: [String: Any] = ["userToken": UserService.shared.getToken()]
        APIController.request(InfoUser.self, .getInfoUser, params: params) { error, data in
            if let infoUser = data {
                completion(infoUser, nil)
                return
            }
            completion(nil ,error)
            print("Lỗi getInfoUser")
        }
    }
    // Put Update Profile
    static func putUpdateProfile(_ imgString: String, _ name: String, _ birthday: String, _ address: String, _ phone: String, _ email: String, _ completion: @escaping(UpdateProfile?, String?) -> ()) {
        let params: [String: Any] = [
            "avatarPr": "data:image/gif;base64," + imgString,
            "data": [
                "name": name,
                "emailUser": email,
                "dateOfBirth": birthday,
                "phoneNumber": phone,
                "placeOfBirth": address
            ]
        ]
        APIController.request(UpdateProfile.self, .updateProfile, params: params) { error, data in
            if let updateProfile = data {
                completion(updateProfile, nil)
                return
            }
            completion(nil,error)
            print("Lỗi updateProfile")
        }
    }
    // Get list product
    static func getListProduct(keyword: String, _ completion: @escaping(ExploreProducts?, String?) -> ()) {
        
        let params: [String: Any] = ["keyword": keyword, "category": "", "classify": ""]
        APIController.request(ExploreProducts.self, .getListProduct, params: params) { error, data in
            if let exfloreProducts = data {
                completion(exfloreProducts,nil)
                return
            }
            completion(nil, error)
            print("Lỗi getExploreProducts")
        }
    }
    // Get Detail Product
    static func getDetailProduct(with productID: String, _ completion: @escaping(DetailProduct?, String?) -> ()) {
        APIController.request(DetailProduct.self, .getDetailProduct(productID)) { error, data in
            if let detailProduct = data {
                completion(detailProduct,nil)
                return
            }
            completion(nil, error)
            print("Lỗi getDetailProduct")
        }
    }
    //Get Reviews Comment
    static func getReviewComment(with id: String, _ completion: @escaping(RevỉewComment?, String?) -> ()) {
        let params: [String: Any] = ["id": id]
        APIController.request(RevỉewComment.self, .getReviewComment, params: params) { error, data in
            if let reviewComment = data {
                completion(reviewComment, nil)
                return
            }
            completion(nil, error)
            print("Lỗi getReviewComment")
        }
    }
    //Add New Product
    static func addNewProduct(price: Double, name: String, description: String, classify: String, category: String, stock: Int, imgString: String, _ completion: @escaping(AddProduct?, String?) ->()) {
        let params: [String: Any] = [
            "params": [
                "userToken": UserService.shared.getToken()
            ],
            "data": [
                "price": price,
                "name": name,
                "description": description,
                "classify": classify,
                "category": category,
                "stock": stock,
                "image": "data:image/gif;base64," + imgString
                
            ]
        ]
        
        APIController.request(AddProduct.self, .addNewProduct, params: params) { error, data in
            if let product = data {
                completion(product, nil)
                return
            }
            completion(nil, error)
            print("Lỗi addNewProduct")
        }
  
    }
    //Edit Product
    static func editProduct(productID: String, price: Double, name: String, description: String, classify: String, category: String, stock: Int, imgString: String, _ completion: @escaping(AddProduct?, String?) ->()) {
        let params: [String: Any] = [
            "params": [
                "userToken": UserService.shared.getToken()
            ],
            "data": [
                "price": price,
                "name": name,
                "description": description,
                "classify": classify,
                "category": category,
                "stock": stock,
                "image": "data:image/gif;base64," + imgString
                
            ]
        ]
        
        APIController.request(AddProduct.self, .editProduct(productID), params: params) { error, data in
            if let product = data {
                completion(product, nil)
                return
            }
            completion(nil, error)
            print("Lỗi addNewProduct")
        }
  
    }
    
    static func deleteProduct(productID: String, _ completion: @escaping(DeleteProduct?, String?) ->()) {
        let params: [String: Any] = [
            "params": [
                "userToken": UserService.shared.getToken()
            ]
        ]
        
        APIController.request(DeleteProduct.self, .deleteProduct(productID), params: params) { error, data in
            if let product = data {
                completion(product, nil)
                return
            }
            completion(nil, error)
            print("Lỗi deleteProduct")
        }
  
    }
    
    static func getListCustomer(keyword: String, _ completion: @escaping(ListCustomer?, String?) -> ()) {
        let params: [String: Any] = [
            "keyword": keyword,
            "userToken": UserService.shared.getToken()
        ]
        
        APIController.request(ListCustomer.self, .getListCustomer, params: params) { error, data in
            if let customers = data {
                completion(customers, nil)
                return
            }
            completion(nil, error)
            print("Lỗi getListCustomer")
        }
    }
    
    static func detailCustomer(customerID: String, _ completion: @escaping(InfoUser?, String?) -> ()) {
        let params: [String: Any] = ["userToken": UserService.shared.getToken()]
       
        APIController.request(InfoUser.self, .detailCustomer(customerID), params: params) { error, data in
            if let customer = data {
                completion(customer, nil)
                return
            }
            completion(nil, error)
            print("Lỗi detailCustomer")
        }
    }
    
    static func updateRole(imgString: String, name: String, birthday: String, address: String, phone: String, email: String, customerID: String, role: String?, _ completion: @escaping(UpdateRole?, String?) -> ()) {
        let params: [String: Any] = [
            "avatarPr": "data:image/gif;base64," + imgString,
            "data": [
                "name": name,
                "emailUser": email,
                "dateOfBirth": birthday,
                "phoneNumber": phone,
                "placeOfBirth": address,
                "role": role
            ]
        ]
        APIController.request(UpdateRole.self, .updateRole(customerID), params: params) { error, data in
            if let customer = data {
                completion(customer, nil)
                return
            }
            completion(nil, error)
            print("Lỗi updateRole")
        }
    }
    
    static func getListOrder(_ completion: @escaping(ListOrder?, String?) -> ()) {
        APIController.request(ListOrder.self, .getListOrder) { error, data in
            if let order = data {
                completion(order, nil)
                return
            }
            completion(nil, error)
            print("Lỗi getListOrder")
        }
    }
}
   
//
//AF.request("https://tazass.herokuapp.com/api/v1/admin/product/new", method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { reponse in
//    switch reponse.result {
//    case .success(let result):
//        print(result)
//    case .failure(let error):
//        print(error)
//    }
//}
