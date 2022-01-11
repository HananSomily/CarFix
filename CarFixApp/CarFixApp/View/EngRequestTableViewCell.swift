//
//  EngRequestTableViewCell.swift
//  CarFixApp
//
//  Created by Hanan Somily on 29/12/2021.
//

import UIKit
import Firebase
class EngRequestTableViewCell: UITableViewCell {

    @IBOutlet weak var carImage: UIImageView!
    @IBOutlet weak var userName: UILabel!{
        didSet{
            userName.layer.cornerRadius = 5
            userName.clipsToBounds = true
        }
    }
    @IBOutlet weak var userImage: UIImageView!{
        didSet{
            userImage.layer.cornerRadius = 20
            userImage.clipsToBounds = true
        }
    }
    @IBOutlet weak var carDescript: UILabel!{
        didSet{
            carDescript.layer.cornerRadius = 5
            carDescript.clipsToBounds = true
        }
    }
    @IBOutlet weak var companyName: UILabel!{
        didSet{
            companyName.layer.cornerRadius = 5
            companyName.clipsToBounds = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

     
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with post:Post) -> UITableViewCell {
        companyName.text = post.companyName
        carDescript.text = post.description
        carImage.loadImageUsingCache(with: post.imageUrl)
        userName.text = post.user.name
        userImage.loadImageUsingCache(with: post.user.imageUrl)
        return self
    }
    
    override func prepareForReuse() {
        userImage.image = nil
        carImage.image = nil
    }
}
    
    

