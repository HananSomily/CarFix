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
