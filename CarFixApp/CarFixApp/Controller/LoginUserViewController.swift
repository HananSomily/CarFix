//
//  loginUserViewController.swift
//  CarFixApp
//
//  Created by Hanan Somily on 27/12/2021.
//

import UIKit
import Firebase
class LoginUserViewController: UIViewController {
    var activityIndicator = UIActivityIndicatorView()

    @IBOutlet weak var emailUserTextField: UITextField!
    
    @IBOutlet weak var passwardUserTextField: UITextField!
  //  var select:User?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let send = segue.destination as! HomeUserViewController
//        send.customer = select
//
//    }
    @IBAction func handelLogin(_ sender: Any) {
        if let email = emailUserTextField.text ,
           let passward = passwardUserTextField.text {
            Activity.showIndicator(parentView: self.view, childView: activityIndicator)
            Auth.auth().signIn(withEmail: email, password: passward){
                authResult,error in
                
                if let error = error {
                    Alert.showAlert(strTitle: "Error", strMessage: error.localizedDescription, viewController: self)
                    Activity.removeIndicator(parentView: self.view, childView: self.activityIndicator)
                }
                
                if let _ = authResult{
                    if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeUserNavigation") as? UINavigationController {
                        viewController.modalPresentationStyle = .fullScreen
                        Activity.removeIndicator(parentView: self.view, childView: self.activityIndicator)
                        self.present(viewController, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    @IBAction func handelRegister(_ sender: Any) {
    }
    @IBAction func backTo(segue:UIStoryboardSegue){
        
    }
}
