//
//  AboutCarFixViewController.swift
//  CarFixApp
//
//  Created by Hanan Somily on 08/01/2022.
//

import UIKit

class AboutCarFixViewController: UIViewController {
    
    @IBOutlet weak var imageCarFix: UIImageView!{
        didSet{
            imageCarFix.layer.masksToBounds = false
            imageCarFix.layer.cornerRadius = 20
        }
    }
    
    @IBOutlet weak var aboutAppLabel: UILabel!{
        didSet{
            aboutAppLabel.text = "about".localized
            aboutAppLabel.clipsToBounds = true
            aboutAppLabel.layer.cornerRadius = 20
//            aboutAppLabel.layer.masksToBounds = false
//            aboutAppLabel.layer.cornerRadius = 20
//            aboutAppLabel.layer.shadowColor = UIColor.gray.cgColor
//            aboutAppLabel.layer.shadowOpacity = 0.8
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
}

