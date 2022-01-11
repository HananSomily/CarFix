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
            imageCarFix.layer.cornerRadius = 8
        }
    }
    
    
    @IBOutlet weak var aboutAppLabel: UILabel!{
        didSet{
            aboutAppLabel.text = "about".localized
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

}
