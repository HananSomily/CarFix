//
//  EngRigesterViewController.swift
//  CarFixApp
//
//  Created by Hanan Somily on 27/12/2021.
//

import UIKit
import Firebase
class EngRigesterViewController: UIViewController {

    let imagePickerController = UIImagePickerController()
    var activityIndicator = UIActivityIndicatorView()
    
    @IBOutlet weak var engImageProfil: UIImageView!{
        didSet{
            engImageProfil.layer.borderColor = UIColor.systemBlue.cgColor
            engImageProfil.layer.borderWidth = 3.0
            engImageProfil.layer.cornerRadius = engImageProfil.bounds.height/2
            engImageProfil.isUserInteractionEnabled = true
            let tabGesture = UITapGestureRecognizer(target: self, action: #selector(selectImage))
            engImageProfil.addGestureRecognizer(tabGesture)
        }
    }
    @IBOutlet weak var engEmailTextField: UITextField!
    @IBOutlet weak var engPasswardTextField: UITextField!
    @IBOutlet weak var engConfirPassawrdTextField: UITextField!
    @IBOutlet weak var engNameTextField: UITextField!
    @IBOutlet weak var engPhoneTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePickerController.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func handelRegister(_ sender: Any) {
        print("somthing")
        if let image = engImageProfil.image,
           let imageData = image.jpegData(compressionQuality: 0.80),
           let name = engNameTextField.text ,
           let email = engEmailTextField.text ,
           let passward = engPasswardTextField.text ,
           let confirPassward = engConfirPassawrdTextField.text,
           passward == confirPassward {
            print("ok")
            Activity.showIndicator(parentView: self.view, childView: activityIndicator)
            Auth.auth().createUser(withEmail: email, password: passward) { authResult , error in
                if let error = error {
                    print("Registeration Auth Error",error.localizedDescription)
                }
                if let authReselt = authResult{
                    let storgeRef = Storage.storage().reference(withPath: "engineer/\(authReselt.user.uid)")
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
                            let userData:[String:String] = ["id":authReselt.user.uid,
                                "name":name ,
                                "email":email,
                                "imageUrl":url.absoluteString]
                                dataBase.collection("engineer").document(authReselt.user.uid).setData(userData){
                                    error in
                                    if let error = error {
                                        print("Registeration DataBase Error",error.localizedDescription)
                                    }else {
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
    
    @IBAction func exit(_ sender: Any) {
    }
}
extension EngRigesterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
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
        engImageProfil.image = chosenImage
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
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


