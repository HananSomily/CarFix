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
    
    
    
    @IBOutlet weak var viewPassward: UIButton!
    
             // ------------------- localize -----------------
    
    
    @IBOutlet weak var langougeDisin: UIButton!{
        didSet{
            langougeDisin.setTitle("English".localized, for: .normal)
        }
    }
    
    @IBOutlet weak var helloLabel: UILabel! {
        didSet{
            helloLabel.text = "helo".localized
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
            logInLabel.layer.masksToBounds = false
            logInLabel.layer.cornerRadius = 8
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
            loginDisign.layer.shadowColor = UIColor.black.cgColor
            loginDisign.layer.shadowOpacity = 0.4
            //loginDisign.layer.shadowRadius = 8
        }
    }
    
    
    @IBOutlet weak var disignViewLogIn: UIView! {
        didSet{
            disignViewLogIn.layer.cornerRadius = 8
            disignViewLogIn.layer.masksToBounds = false
            disignViewLogIn.layer.shadowColor = UIColor.black.cgColor
            disignViewLogIn.layer.shadowOpacity = 0.3
        }
    }

    
    @IBOutlet weak var emailEngTextField: UITextField!{
        didSet{
            emailEngTextField.placeholder = "Enter Your Email".localized
        }
    }
    @IBOutlet weak var passwardEngTextField: UITextField!{
        didSet{
            passwardEngTextField.placeholder = "Enter Your Passward".localized
//            passwardEngTextField.textContentType = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
         //   passwardEngTextField.enablePasswordToggle()

        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //
        passwardEngTextField.rightView = viewPassward
        passwardEngTextField.rightViewMode = .whileEditing
        //
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
                tap.cancelsTouchesInView = false
                view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
        
        emailEngTextField.delegate = self
        passwardEngTextField.delegate = self

//        setTextFieldSpace( textField :passwardEngTextField)

//        passwardEngTextField.rightView = eyePassword
//                passwardEngTextField.rightViewMode = .whileEditing

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
                    if let currentUser = Auth.auth().currentUser {
                    let db = Firestore.firestore()
                    db.collection("users").document(currentUser.uid).getDocument { userSnapshot , error in
                        if let error = error {
                            print(error)
                        }
                      if let userSnapshot = userSnapshot,
                         let userData = userSnapshot.data(){
                          let user = User(dict: userData)
                          if user.customer {
                              if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeUserNavigation") as? UINavigationController {
                                  viewController.modalPresentationStyle = .fullScreen
                                  Activity.removeIndicator(parentView: self.view, childView: self.activityIndicator)
                                  self.present(viewController, animated: true, completion: nil)
                              }
                            }
                          }
                          db.collection("engineer").document(currentUser.uid).getDocument { userSnapshot , error in
                              if let error = error {
                                  print(error)
                              }
                            if let userSnapshot = userSnapshot,
                               let userData = userSnapshot.data(){
                                let user = User(dict: userData)
                                if !user.customer {
                                    if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeEngNavigationBar") as? UINavigationController {
                                        viewController.modalPresentationStyle = .fullScreen
                                        Activity.removeIndicator(parentView: self.view, childView: self.activityIndicator)
                                        self.present(viewController, animated: true, completion: nil)
                                    }
                                }
                             }
                          }
                       }
                    }
                }
            }
        }
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
    

    @IBAction func viewPassward(_ sender: AnyObject) {
                passwardEngTextField.isSecureTextEntry.toggle()
                        if  passwardEngTextField.isSecureTextEntry {
                            if let image = UIImage(systemName: "eye.circle") {
                                sender.setImage(image, for: .normal)
                            }
                        } else {
                            if let image = UIImage(systemName: "eye.slash.circle") {
                                sender.setImage(image, for: .normal)
                            }
                        }
                    }

    
    @IBAction func handelRegister(_ sender: Any) {
    }
    @IBAction func backTo(segue:UIStoryboardSegue){
        
    }
    
    @IBAction func eyePas(_ sender: UIButton) {
            passwardEngTextField.isSecureTextEntry.toggle()
            if passwardEngTextField.isSecureTextEntry {
                if let image = UIImage(systemName: "eye.fill") {
                    sender.setImage(image, for: .normal)
                }
            } else {
                if let image = UIImage(systemName: "eye.slash.fill"){
                    sender.setImage(image, for: .normal)
                }
            }
        }
    
    
//    func setTextFieldSpace( textField :UITextField){
//        let lblSpace = UILabel()
//        lblSpace.frame = CGRect.init(x: 0, y: 0, width: 15, height: 15)
//        lblSpace.backgroundColor = .clear
//        textField.leftView = lblSpace
//
//        textField.leftViewMode = .always
//        textField.contentVerticalAlignment =  .center
//    }
    
}



extension UIViewController: UITextFieldDelegate{
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
}

