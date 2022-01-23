//
//  RegisterViewController.swift
//  CarFixApp
//
//  Created by Hanan Somily on 08/01/2022.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var massegeLabel: UILabel!{
        didSet{
            massegeLabel.text = "Create an account as".localized
        }
    }
    @IBOutlet weak var customerButton: UIButton!{
        didSet{
            customerButton.setTitle("customer".localized, for: .normal)
        }
    }
    @IBOutlet weak var orLabel: UILabel!{
        didSet{
            orLabel.text = "OR".localized
        }
    }
    @IBOutlet weak var serviceButton: UIButton!{
        didSet{
            serviceButton.setTitle("service provider".localized, for: .normal)
        }
    }
    
    @IBOutlet weak var designView: UIView!{
        didSet{
            designView.layer.cornerRadius = 8
            designView.layer.masksToBounds = false
            designView.layer.shadowColor = UIColor.gray.cgColor
            designView.layer.shadowOpacity = 0.8
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        //
        let backButton = UIBarButtonItem()
         backButton.title = ""
         self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        // Do any additional setup after loading the view.
    }
    

}
