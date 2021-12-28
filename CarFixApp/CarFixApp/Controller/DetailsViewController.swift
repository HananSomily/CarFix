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

    var postes:Post?
    
    var selectedPosts: Post?
    var customer: User?
    var selectedPostImage:UIImage?
    
    @IBOutlet weak var DisplayPeoplem: UITextField!
    
    @IBOutlet weak var viewImage: UIImageView! {
        didSet{
            viewImage.isUserInteractionEnabled = true
            let tabGesture = UITapGestureRecognizer(target: self, action: #selector(selectImage))
            viewImage.addGestureRecognizer(tabGesture)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        DisplayPeoplem.text = postes?.description
       // viewImage.image = postes?.imageUrl
        // Do any additional setup after loading the view.
   
    
        if let selectedPosts = selectedPosts ,
        let selectedImage = selectedPostImage {
            DisplayPeoplem.text = selectedPosts.description
            viewImage.image = selectedImage
//            actionSave.setTitle("Update Post", for: .normal)
//            let deleteBarButton = UIBarButtonItem(image: UIImage(systemName: "trash.fill"), style: .plain, target: self, action: #selector(handleDelete))
//            self.navigationItem.rightBarButtonItem = deleteBarButton
//        }else {
//            actionSave.setTitle("Add Post", for: .normal)
//            self.navigationItem.rightBarButtonItem = nil
//        }
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
    
    @objc func handleDelete (_ sender: UIBarButtonItem) {
        let ref = Firestore.firestore().collection("posts")
        if let selectedPost = selectedPosts {
            Activity.showIndicator(parentView: self.view, childView: activityIndicator)
            ref.document(selectedPost.id).delete { error in
                if let error = error {
                    print("Error in db delete",error)
                }else {
                    // Create a reference to the file to delete
                    let storageRef = Storage.storage().reference(withPath: "posts/\(selectedPost.user.id)/\(selectedPost.id)")
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
    }
    
    @IBAction func actionUpdate(_ sender: Any) {
        
        if let image = viewImage.image,
           let imageData = image.jpegData(compressionQuality: 0.80),
           let description = DisplayPeoplem.text ,
            let currentUser = Auth.auth().currentUser {
                Activity.showIndicator(parentView: self.view, childView: activityIndicator)
                var postId = ""
            if let selectedPosts = selectedPosts {
                postId = selectedPosts.id
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
                            "id":selectedPost.user.id,
                            "description":description,
                            "imageUrl":url.absoluteString,
                            "createdAt":selectedPost.createdAt ?? FieldValue.serverTimestamp(),
                            "updatedAt": FieldValue.serverTimestamp()
                                ]
                    } else {
                        postData = [
                            "id":currentUser.uid,
                            "description":description,
                            "imageUrl":url.absoluteString,
                            "createdAt":FieldValue.serverTimestamp(),
                            "updatedAt": FieldValue.serverTimestamp()                        ]
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
        }
        
    @IBAction func actionDelet(_ sender: Any) {
    }
    
}

extension DetailsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @objc func selectImage() {
        showAlert()
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "choose problem Picture", message: "where do you want to pick your image from?", preferredStyle: .actionSheet)
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
        viewImage.image = chosenImage
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
