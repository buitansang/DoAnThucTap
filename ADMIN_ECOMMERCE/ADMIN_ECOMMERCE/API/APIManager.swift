//
//  APIManager.swift
//  ADMIN_ECOMMERCE
//
//  Created by Sang Hi Bùi on 24/07/2022.
//

import Foundation

import Alamofire

enum APIManager {
    case login
    case getInfoUser
    case updateProfile
    case getListProduct
    case getDetailProduct(String)
    case getReviewComment
    case addNewProduct
    case editProduct(String)
    case deleteProduct(String)
    case getListCustomer
    case detailCustomer(String)
    case updateRole(String)
    case getListOrder
    case getOrderByID(String)
    case updateOrderStatus(String)
    case analyticsUser
    case analyticsOrder
    case analyticsProduct
    case analyticsPayment
    case getDiscounts
    case createDiscount
}

extension APIManager {
    var baseURL: String  { return "https://tazass.herokuapp.com/api/v1"}
    
    //MARK: - URL
    var url: String {
        var path = ""
         
        switch  self {
        case .login: path = "/user/login"
        case .getInfoUser: path = "/me"
        case .updateProfile: path = "/user/update-profile?userToken=\(UserService.shared.getToken())"
        case .getListProduct: path = "/products-home"
        case .getDetailProduct(let productID): path = "/product/\(productID)"
        case .getReviewComment: path = "/reviews"
        case .addNewProduct: path = "/admin/product/new"
        case .editProduct(let productID): path = "/admin/product/\(productID)"
        case .deleteProduct(let productID): path = "/admin/product/\(productID)"
        case .getListCustomer: path = "/admin/users"
        case .detailCustomer(let customerID): path = "/admin/user/\(customerID)"
        case .updateRole(let customerID): path = "/admin/user/\(customerID)?userToken=\(UserService.shared.getToken())"
        case .getListOrder: path = "/all/orders"
        case .getOrderByID(let orderID): path = "/admin/order/\(orderID)?userToken=\(UserService.shared.getToken())"
        case .updateOrderStatus(let orderID): path = "/admin/order/\(orderID)"
        case .analyticsUser: path = "/analytics-by-user"
        case .analyticsOrder: path = "/analytics-by-order"
        case .analyticsProduct: path = "/analytics-by-product"
        case .analyticsPayment: path = "/analytics-payment"
        case .getDiscounts: path = "/admin/discounts"
        case .createDiscount: path = "/create-discount"
   
        }
        return baseURL + path
    }
    
    //MARK: - METHOD
    var method: HTTPMethod {
        switch self {
        case .getInfoUser, .getListProduct, .getDetailProduct, .getReviewComment, .getListCustomer, .detailCustomer, .getListOrder, .getOrderByID, .analyticsUser, .analyticsOrder,  .analyticsProduct, .analyticsPayment, .getDiscounts :
            return .get
        case .login, .addNewProduct, .createDiscount :
            return .post
        case .updateProfile, .editProduct, .updateRole, .updateOrderStatus :
            return .put
        case .deleteProduct :
            return .delete
        }
        
    }
    
    //MARK: - HEADER
    var header: HTTPHeader? {
        switch self {
        default:
            return nil
        }
    }
    
    //MARK: - ENCODING
    var encoding: ParameterEncoding {
        switch self.method {
        case .get:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
}

