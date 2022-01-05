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
    
    // ------------------- localize -----------------
    @IBOutlet weak var helloLabel: UILabel!{
        didSet{
            helloLabel.text = "customer".localized
        }
    }
    @IBOutlet weak var emailLabel: UILabel!{
        didSet{
            emailLabel.text = "Email".localized
        }
    }
    @IBOutlet weak var passawrdLabel: UILabel!{
        didSet{
            passawrdLabel.text = "Passward".localized
        }
    }
    @IBOutlet weak var logInButton: UIButton!{
        didSet{
            logInButton.setTitle("log in".localized, for: .normal)
        }
    }
    @IBOutlet weak var orLabel: UILabel!{
        didSet{
            orLabel.text = "OR".localized
        }
    }
    @IBOutlet weak var registerButton: UIButton!{
        didSet{
            registerButton.setTitle("register".localized, for: .normal)
        }
    }
    
    @IBOutlet weak var massegeRegisterLabel: UILabel!{
        didSet{
            massegeRegisterLabel.text = "Don't have acount".localized
        }
    }
    // ------------------- localize -----------------

    
    
    
    @IBOutlet weak var loginDisign: UIStackView!{
        didSet{
            loginDisign.layer.cornerRadius = 5
            loginDisign.layer.masksToBounds = false
            loginDisign.layer.shadowColor = UIColor.white.cgColor
            loginDisign.layer.shadowOpacity = 0.5
            //loginDisign.layer.shadowRadius = 8
        }
    }
    
    
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


    
    @IBOutlet weak var emailUserTextField: UITextField!
    
    @IBOutlet weak var passwardUserTextField: UITextField!
  //  var select:User?
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
                tap.cancelsTouchesInView = false
                view.addGestureRecognizer(tap)
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
    @IBAction func changeLangouge(_ sender: Any) {
        var lang = UserDefaults.standard.string(forKey: "currentLanguage")
                 if lang == "ar" {
                     Bundle.setLanguage(lang ?? "ar")
                     UIView.appearance().semanticContentAttribute = .forceRightToLeft
                    lang = "en"
                }else{
                    Bundle.setLanguage(lang ?? "en")
                    UIView.appearance().semanticContentAttribute = .forceLeftToRight
                    lang = "ar"
                }
                UserDefaults.standard.set(lang, forKey: "currentLanguage")
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let sceneDelegate = windowScene.delegate as? SceneDelegate {
                    sceneDelegate.window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "HomeNavigationController")
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
            
}


extension String{
    var localized: String {
        return NSLocalizedString(self, tableName: "localize", bundle: .main, value: self, comment: self)
    }
}
