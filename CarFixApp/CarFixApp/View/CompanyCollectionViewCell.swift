//
//  CompanyCollectionViewCell.swift
//  CarFixApp
//
//  Created by Hanan Somily on 28/12/2021.
//

import UIKit

class CompanyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageOfCompany: UIImageView! {
        didSet {
            imageOfCompany.layer.cornerRadius = 20
            imageOfCompany.clipsToBounds = true
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
