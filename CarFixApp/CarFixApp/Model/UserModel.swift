//
//  UserModel.swift
//  CarFixApp
//
//  Created by Hanan Somily on 27/12/2021.
//

import Foundation

struct User{
    
var id:String = ""
var name:String = ""
var email:String = ""
var imageUrl:String = ""
var phoneNumber:String = ""
var customer:Bool = false
    init(dict:[String:Any]){
        if let id = dict["id"] as? String ,
           let name = dict["name"] as? String ,
           let email = dict["email"] as? String ,
           let imageUrl = dict["imageUrl"] as? String,
           let customer = dict["customer"] as? Bool,
           let phoneNumber = dict["phoneNumber"] as? String
        {
            self.id = id
            self.name = name
            self.email = email
            self.imageUrl = imageUrl
            self.phoneNumber = phoneNumber
            self.customer = customer
            
        }
    }
}
