//
//  EngRequestTableViewCell.swift
//  CarFixApp
//
//  Created by Hanan Somily on 29/12/2021.
//

import UIKit

class EngRequestTableViewCell: UITableViewCell {

    @IBOutlet weak var carImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var carDescript: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with post:Post) -> UITableViewCell {
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
    
    

