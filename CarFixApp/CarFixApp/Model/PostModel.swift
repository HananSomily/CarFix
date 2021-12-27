//
//  PostModel.swift
//  CarFixApp
//
//  Created by Hanan Somily on 27/12/2021.
//

import Foundation
import Firebase
struct Post {
var id:String = ""
var user :User
var imageUrl : String = ""
var description:String = ""
    var createdAt:Timestamp?
    init(dict:[String:Any],id:String , user:User){
    if let description = dict["description"]as? String,
    let imageUrl = dict["imageUrl"] as? String,
    let createdAt = dict["createdAt"] as? Timestamp{
        self.description = description
        self.imageUrl = imageUrl
        self.createdAt = createdAt
        }
        self.id = id
        self.user = user
    }
}
