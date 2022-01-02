//
//  EngLoginViewController.swift
//  CarFixApp
//
//  Created by Hanan Somily on 27/12/2021.
//

import UIKit
import Firebase
class EngLoginViewController: UIViewController {
    var activityIndicator = UIActivityIndicatorView()
    
             // ------------------- localize -----------------
    @IBOutlet weak var helloLabel: UILabel! {
        didSet{
            helloLabel.text = "hellllo"
        }
    }
    @IBOutlet weak var emailLabel: UILabel!{
        didSet{
            emailLabel.text = "Email".localized
        }
    }
    @IBOutlet weak var passwardLabel: UILabel!{
        didSet{
            passwardLabel.text = "Passward".localized
        }
    }
    @IBOutlet weak var logInLabel: UIButton!{
        didSet{
            logInLabel.setTitle("log in".localized, for: .normal)
        }
    }
    @IBOutlet weak var orLabel: UILabel!{
        didSet{
            orLabel.text = "OR".localized
        }
    }
    @IBOutlet weak var registerLabel: UIButton!{
        didSet{
            registerLabel.setTitle("register".localized, for: .normal)
        }
    }
    @IBOutlet weak var tabBarChangeName: UITabBarItem!{
        didSet{
            
        }
    }
             // ------------------- localize -----------------
    
    
    // ---------+++++ language Segment +++++------------
    
    @IBOutlet weak var languageSegmentControl: UISegmentedControl! {
        didSet {
            if let lang = UserDefaults.standard.string(forKey: "currentLanguage") {
                switch lang {
                case "ar":
                    languageSegmentControl.selectedSegmentIndex = 0
                case "en":
                    languageSegmentControl.selectedSegmentIndex = 1
                default:
                    let localLang =  Locale.current.languageCode
                     if localLang == "ar" {
                         languageSegmentControl.selectedSegmentIndex = 0
                     }else {
                         languageSegmentControl.selectedSegmentIndex = 1
                     }
                  
                }
            
            }else {
                let localLang =  Locale.current.languageCode
                 if localLang == "ar" {
                     languageSegmentControl.selectedSegmentIndex = 0
                 }else {
                     languageSegmentControl.selectedSegmentIndex = 1
                 }
            }
        }
    }
    
    // ---------+++++ language Segment +++++------------

    
    @IBOutlet weak var emailEngTextField: UITextField!
    @IBOutlet weak var passwardEngTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func handelLogin(_ sender: Any) {
        if let email = emailEngTextField.text ,
           let passward = passwardEngTextField.text {
            Activity.showIndicator(parentView: self.view, childView: activityIndicator)
            Auth.auth().signIn(withEmail: email, password: passward){
                authResult,error in
                
                if let error = error {
                    Alert.showAlert(strTitle: "Error", strMessage: error.localizedDescription, viewController: self)
                    Activity.removeIndicator(parentView: self.view, childView: self.activityIndicator)
                }
                
                if let _ = authResult{
                    if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeEngNavigationBar") as? UINavigationController {
                        viewController.modalPresentationStyle = .fullScreen
                        Activity.removeIndicator(parentView: self.view, childView: self.activityIndicator)
                        self.present(viewController, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    @IBAction func segmentedLangouge(_ sender: UISegmentedControl) {
        
        if let lang = sender.titleForSegment(at:sender.selectedSegmentIndex)?.lowercased() {
            UserDefaults.standard.set(lang, forKey: "currentLanguage")
            Bundle.setLanguage(lang)
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let sceneDelegate = windowScene.delegate as? SceneDelegate {
                sceneDelegate.window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "HomeNavigationController")
            }
        }
    }
            
    
    @IBAction func handelRegister(_ sender: Any) {
    }
    @IBAction func backTo(segue:UIStoryboardSegue){
        
    }
}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

