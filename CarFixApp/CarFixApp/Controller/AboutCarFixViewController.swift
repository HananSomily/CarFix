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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
