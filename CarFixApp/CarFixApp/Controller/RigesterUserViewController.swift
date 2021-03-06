//
//  RigesterUserViewController.swift
//  CarFixApp
//
//  Created by Hanan Somily on 27/12/2021.
//

import UIKit
import Firebase

class RigesterUserViewController: UIViewController {
    let imagePickerController = UIImagePickerController()
    var activityIndicator = UIActivityIndicatorView()
    
    
    // ------------------- localize -----------------

    
//    @IBOutlet weak var helloLabel: UILabel!{
//        didSet{
//            helloLabel.text = "hhhi"
//       }
//    }
        @IBOutlet weak var emailLabel: UILabel!{
            didSet{
                emailLabel.text = "Email".localized
            }
        }
    @IBOutlet weak var nameLabel: UILabel!{
        didSet{
            nameLabel.text = "Name".localized
        }
    }
    @IBOutlet weak var passwardLabel: UILabel!{
        didSet{
            passwardLabel.text = "Passward".localized
        }
    }
    @IBOutlet weak var checkPassLabel: UILabel!{
        didSet{
            checkPassLabel.text = "Passwardcheck".localized
        }
    }
    @IBOutlet weak var phoneLabel: UILabel!{
        didSet{
            phoneLabel.text = "Phone".localized
        }
    }
    
    @IBOutlet weak var regsterButton: UIButton!{
        didSet{
            regsterButton.setTitle("register".localized, for: .normal)
        }
    }
    
    @IBOutlet weak var showPassward: UIButton!
    
    @IBOutlet weak var showConfirmPassward: UIButton!
    // ------------------- localize -----------------

    

    @IBOutlet weak var userImageProfil: UIImageView!{
        didSet{
            userImageProfil.layer.borderColor = UIColor.black.cgColor
            userImageProfil.layer.borderWidth = 3.0
            userImageProfil.layer.cornerRadius = userImageProfil.bounds.height/2
            userImageProfil.isUserInteractionEnabled = true
            let tabGesture = UITapGestureRecognizer(target: self, action: #selector(selectImage))
            userImageProfil.addGestureRecognizer(tabGesture)
        }
    }
    @IBOutlet weak var userEmailTextField: UITextField!{
        didSet{
            userEmailTextField.placeholder = "Enter Your Email".localized
        }
    }
    @IBOutlet weak var userPasswardTextField: UITextField!{
        didSet{
            userPasswardTextField.placeholder = "Enter Your Passward".localized
        }
    }
    @IBOutlet weak var userConfirPassawrdTextField: UITextField!{
        didSet{
            userConfirPassawrdTextField.placeholder = "Confirm Passward".localized
        }
    }
    @IBOutlet weak var userNameTextField: UITextField!{
        didSet{
            userNameTextField.placeholder = "Enter Your Name".localized
        }
    }
    @IBOutlet weak var userPhoneTextField: UITextField!{
        didSet{
            userPhoneTextField.placeholder = "Enter Phone Number".localized
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        imagePickerController.delegate = self
       //
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
                tap.cancelsTouchesInView = false
                view.addGestureRecognizer(tap)
        //
        let backButton = UIBarButtonItem()
         backButton.title = ""
         self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        
        //initalSteup()
    // -.-.-.-.-.-.- show passward -.-.-.-.-.-
        userPasswardTextField.rightView = showPassward
        userPasswardTextField.rightViewMode = .whileEditing
        userConfirPassawrdTextField.rightView = showConfirmPassward
        userConfirPassawrdTextField.rightViewMode = .whileEditing
    // -.-.-.-.-.-.- show passward -.-.-.-.-.-

    }
    
    @IBAction func handelRegister(_ sender: Any) {
       // print("somthing")
        if let image = userImageProfil.image,
           let imageData = image.jpegData(compressionQuality: 0.80),
           let name = userNameTextField.text ,
           // customer = true ,
           let phoneNumber = userPhoneTextField.text,
           let email = userEmailTextField.text ,
           let passward = userPasswardTextField.text ,
           let confirPassward = userConfirPassawrdTextField.text,
           passward == confirPassward {
            print("ok")
            
            Activity.showIndicator(parentView: self.view, childView: activityIndicator)
            Auth.auth().createUser(withEmail: email, password: passward) { authResult , error in
                
                if let error = error {
                    Alert.showAlert(strTitle: "Error", strMessage: error.localizedDescription, viewController: self)
                    Activity.removeIndicator(parentView: self.view, childView: self.activityIndicator)
                }
                if let authReselt = authResult{
                    let storgeRef = Storage.storage().reference(withPath: "users/\(authReselt.user.uid)")
                    let uploadMeta = StorageMetadata.init()
                    uploadMeta.contentType = "image/jpeg"
                    storgeRef.putData(imageData,metadata: uploadMeta){ storageMeta , error in
                        if let error = error{
                            print("Registeration Auth Error",error.localizedDescription)
                        }
                        storgeRef.downloadURL { url, error in
                            if let error = error {
                                print("Registeration Storage Dawnload URL Error",error.localizedDescription)
                            }
                            if let url = url{
                                print("URL",url.absoluteString)
                            let dataBase = Firestore.firestore()
                            let userData:[String:Any] = ["id":authReselt.user.uid,
                                "name":name ,
                                "email":email,
                               "customer": true ,
                               "phoneNumber":phoneNumber,
                                "imageUrl":url.absoluteString]
                                dataBase.collection("users").document(authReselt.user.uid).setData(userData){
                                    error in
                                    if let error = error {
                                        print("Registeration DataBase Error",error.localizedDescription)
                                    }else {
                                            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeUserNavigation") as? UINavigationController {
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
        } else {
            Alert.showAlert(strTitle: "Error", strMessage: "Password confirmation doesn't match Password", viewController: self)
        }
    }
    
    
    @IBAction func viewPassward(_ sender: AnyObject) {
           userPasswardTextField.isSecureTextEntry.toggle()
                        if  userPasswardTextField.isSecureTextEntry {
                            if let image = UIImage(systemName: "eye.circle") {
                                sender.setImage(image, for: .normal)
                            }
                        } else {
                            if let image = UIImage(systemName: "eye.slash.circle") {
                                sender.setImage(image, for: .normal)
                            }
                        }
                    }
    @IBAction func viewPasswardConfirm(_ sender: AnyObject) {
                userConfirPassawrdTextField.isSecureTextEntry.toggle()
                        if  userConfirPassawrdTextField.isSecureTextEntry {
                            if let image = UIImage(systemName: "eye.circle") {
                                sender.setImage(image, for: .normal)
                            }
                        } else {
                            if let image = UIImage(systemName: "eye.slash.circle") {
                                sender.setImage(image, for: .normal)
                            }
                        }
                    }
    
    
    @IBAction func exit(_ sender: Any) {
    }
    
    // -------------------- Keyboard properties ----------------
private func initalSteup(){
 
 self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboarde)))
 
 NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
 NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
}
@objc private func hideKeyboarde(){
 self.view.endEditing(true)
}

@objc private func keyboardWillShow(notification:NSNotification){

 guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
    // if keyboard size is not available for some reason, dont do anything
    return
 }

// move the root view up by the distance of keyboard height
self.view.frame.origin.y = 100 - keyboardSize.height
}
@objc private func keyboardWillHide(){
 self.view.frame.origin.y = 0
}
deinit{
 NotificationCenter.default.removeObserver(self , name: UIResponder.keyboardWillShowNotification,object: nil)
 NotificationCenter.default.removeObserver(self , name: UIResponder.keyboardWillHideNotification,object: nil)
}

// -------------------- Keyboard properties ----------------
    
}
extension RigesterUserViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @objc func selectImage() {
        showAlert()
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "choose Profile Picture", message: "where do you want to pick your image from?", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { Action in
            self.getImage(from: .camera)
        }
        let galaryAction = UIAlertAction(title: "photo Album", style: .default) { Action in
            self.getImage(from: .photoLibrary)
        }
        let dismissAction = UIAlertAction(title: "Cancle", style: .destructive) { Action in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(cameraAction)
        alert.addAction(galaryAction)
        alert.addAction(dismissAction)
        self.present(alert, animated: true, completion: nil)
    }
    func getImage( from sourceType: UIImagePickerController.SourceType) {
        
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            imagePickerController.sourceType = sourceType
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return}
        userImageProfil.image = chosenImage
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}


