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
var imageURL:String = ""
var phoneNumber:Int = 0
    init(dict:[String:Any]){
        if let id = dict["id"] as? String ,
           let name = dict["name"] as? String ,
           let email = dict["email"] as? String ,
           let imageURL = dict["imageURL"] as? String {
            self.id = id
            self.name = name
            self.email = email
            self.imageURL = imageURL
        }
    }
}
