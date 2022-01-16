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
//    var latitudeUser :Double = 0.0
//    var longitudeUser : Double = 0.0
    var companyName:String = ""
    var createdAt:Timestamp?
    init(dict:[String:Any],userId:String , user:User){
    if let description = dict["description"]as? String,
    let imageUrl = dict["imageUrl"] as? String,
    let companyName = dict["companyName"] as? String,
    let location = dict["location"] as? String,
//    let longitudeNow = dict["longitudeUser"] as? Double ,
//    let latitudeNow = dict["latitudeUser"] as? Double ,
    let createdAt = dict["createdAt"] as? Timestamp{
        self.description = description
        self.imageUrl = imageUrl
        self.createdAt = createdAt
        self.location = location
        self.companyName = companyName
//        self.latitudeUser = latitudeNow
//        self.longitudeUser = longitudeNow
        
        }
        self.userId = userId
        self.user = user
    }
}
