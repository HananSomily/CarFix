//
//  PostModel.swift
//  CarFixApp
//
//  Created by Hanan Somily on 27/12/2021.
//

import Foundation
import Firebase
struct Post {
var userId:String = ""
var user :User
var imageUrl : String = ""
var description:String = ""
var location :String = ""
    var companyName:String = ""
    var createdAt:Timestamp?
    init(dict:[String:Any],userId:String , user:User){
    if let description = dict["description"]as? String,
    let imageUrl = dict["imageUrl"] as? String,
    let companyName = dict["companyName"] as? String,
    let location = dict["location"] as? String,
    let createdAt = dict["createdAt"] as? Timestamp{
        self.description = description
        self.imageUrl = imageUrl
        self.createdAt = createdAt
        self.location = location
        self.companyName = companyName
        }
        self.userId = userId
        self.user = user
    }
}
