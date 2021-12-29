//
//  malfunctionsCarTableViewCell.swift
//  CarFixApp
//
//  Created by Hanan Somily on 29/12/2021.
//

import UIKit
import Firebase
class malfunctionsCarTableViewCell: UITableViewCell {

    @IBOutlet weak var malfunctionImage: UIImageView!
    @IBOutlet weak var malfunctionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configure(with post:Post) -> UITableViewCell {
        malfunctionLabel.text = post.description
        malfunctionImage.loadImageUsingCache(with: post.imageUrl)

        return self
    }
    
    override func prepareForReuse() {
        malfunctionImage.image = nil
    }
    
}
