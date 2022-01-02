//
//  DetailsViewController.swift
//  CarFixApp
//
//  Created by Hanan Somily on 27/12/2021.
//

import UIKit
import Firebase
class DetailsViewController: UIViewController {
    let imagePickerController = UIImagePickerController()
    let activityIndicator = UIActivityIndicatorView()
    
    // ------------------- localize -----------------
    
    @IBOutlet weak var closeButton: UIButton!{
        didSet{
            closeButton.setTitle("close".localized, for: .normal)
        }
    }

    @IBOutlet weak var updateButton: UIButton!{
    didSet{
        updateButton.setTitle("update".localized, for: .normal)
        }
    }
    
    
    // ------------------- localize -----------------

    
    var castomer:User?
    var selectedPosts: Post?
    var selectedPostImage:UIImage?
    
    @IBOutlet weak var readLabel: UILabel!
    @IBOutlet weak var DisplayPeoplem: UITextField!
    @IBOutlet weak var chkeing: UILabel!

    @IBOutlet weak var nameOfCompanyLabel: UILabel!
    @IBOutlet weak var viewImage: UIImageView! {
        didSet{
            viewImage.isUserInteractionEnabled = true
            let tabGesture = UITapGestureRecognizer(target: self, action: #selector(selectImage))
            viewImage.addGestureRecognizer(tabGesture)
        }
    }
    
    @IBOutlet weak var locationUserLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let selectedPosts = selectedPosts ,
        let selectedPostImage = selectedPostImage {
            readLabel.text = selectedPosts.description
            viewImage.image = selectedPostImage
            locationUserLabel.text = selectedPosts.location
            nameOfCompanyLabel.text = selectedPosts.companyName
        }

    }
   

    @IBAction func actionUpdate(_ sender: Any) {
        
        if let image = viewImage.image,
           let imageData = image.jpegData(compressionQuality: 0.80),
           let description = DisplayPeoplem.text ,
           let location = locationUserLabel.text,
           let companyName = nameOfCompanyLabel.text ,
            let currentUser = Auth.auth().currentUser {
                Activity.showIndicator(parentView: self.view, childView: activityIndicator)
                var postId = ""
            if let selectedPosts = selectedPosts {
                postId = selectedPosts.userId
            }else {
                postId = "\(Firebase.UUID())"
            }
        let storageRef = Storage.storage().reference(withPath: "posts/\(currentUser.uid)/\(postId)")
        let updloadMeta = StorageMetadata.init()
                updloadMeta.contentType = "image/jpeg"
        storageRef.putData(imageData, metadata: updloadMeta) { storageMeta, error in
                    if let error = error {
        print("Upload error",error.localizedDescription)
                    }
                    storageRef.downloadURL { url, error in
                        var postData = [String:Any]()
                        if let url = url {
                            let db = Firestore.firestore()
                            let ref = db.collection("posts")
                    if let selectedPost = self.selectedPosts {
                                postData = [
                            "userId":selectedPost.user.id,
                            "description":description,
                            "imageUrl":url.absoluteString,
                            "companyName": companyName,
                            "location":location,
                            "createdAt":selectedPost.createdAt ?? FieldValue.serverTimestamp(),
                            "updatedAt": FieldValue.serverTimestamp()
                                ]
                    } else {
                        postData = [
                            "userId":currentUser.uid,
                            "description":description,
                            "imageUrl":url.absoluteString,
                            "createdAt":FieldValue.serverTimestamp(),
                            "updatedAt": FieldValue.serverTimestamp()
                        ]
                    }
                            ref.document(postId).setData(postData) { error in
                                if let error = error {
                                    print("FireStore Error",error.localizedDescription)
                                }
                                Activity.removeIndicator(parentView: self.view, childView: self.activityIndicator)
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    }
                }
             }
        print("++++update")
        }
        
    @IBAction func actionDelet(_ sender: Any) {
                let ref = Firestore.firestore().collection("posts")
                if let selectedPost = selectedPosts {
                    Activity.showIndicator(parentView: self.view, childView: activityIndicator)
                    ref.document(selectedPost.userId).delete { error in
                        if let error = error {
                            print("Error in db delete",error)
                        }else {
                            // Create a reference to the file to delete
                            let storageRef = Storage.storage().reference(withPath: "posts/\(selectedPost.user.id)/\(selectedPost.userId)")
                            // Delete the file
                            storageRef.delete { error in
                                if let error = error {
                                    print("Error in storage delete",error)
                                } else {
                                    self.activityIndicator.stopAnimating()
                                    self.navigationController?.popViewController(animated: true)
                                }
                            }
        
                        }
                    }
                }
        //    }
        print("---- delet")
    }
    
}

extension DetailsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @objc func selectImage() {
        showAlert()
    }
    
    private func showAlert() {
        
        let alert = UIAlertController(title: "Choose Profile Picture", message: "From where you want to pick this image?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .camera)
        }))
        alert.addAction(UIAlertAction(title: "Photo Album", style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    //get image from source type
    private func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {
        
        //Check is source type available
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = sourceType
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        viewImage.image = chosenImage
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
