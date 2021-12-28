//
//  HomeUserViewController.swift
//  CarFixApp
//
//  Created by Hanan Somily on 27/12/2021.
//

import UIKit
import Firebase
class HomeUserViewController: UIViewController {
    let imagePickerController = UIImagePickerController()

    var selectedPosts: Post?
    var customer: User?
    var selectedPostImage:UIImage?
    
    @IBOutlet weak var userNameLable: UILabel!
    @IBOutlet weak var userImageProfile: UIImageView!
    @IBOutlet weak var userPhoneLable: UILabel!
    @IBOutlet weak var userEmailLable: UILabel!
    
    @IBOutlet weak var actionSave: UIButton!
    @IBOutlet weak var companyImageViewCollectionView: UICollectionView! {
        didSet{
            companyImageViewCollectionView.delegate = self
            companyImageViewCollectionView.dataSource = self
        }
    }
    var carsComp = ["changan","Chevrolet","Ford","hondae","hyundai","jeep","KIA","Lexus","mazda","MG","nissan","toyota"]
    @IBOutlet weak var cerantLocationLabel: UILabel!
    @IBOutlet weak var descriptionTextField: UITextField! {
        didSet{
            descriptionTextField.delegate = self
        }
    }
    @IBOutlet weak var nameOfCompanyLabel: UILabel!
    @IBOutlet weak var takeImage: UIImageView! {
        didSet{
            takeImage.isUserInteractionEnabled = true
            let tabGesture = UITapGestureRecognizer(target: self, action: #selector(selectImage))
            takeImage.addGestureRecognizer(tabGesture)
        }
    }
    let activityIndicator = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
//        if let customer = customer {
//            userNameLable.text = customer.name
//            userEmailLable.text = customer.email
//            userPhoneLable.text = "\(customer.phoneNumber)"
//        }
            if let selectedPosts = selectedPosts ,
            let selectedImage = selectedPostImage {
                userNameLable.text = selectedPosts.user.name
                userEmailLable.text = selectedPosts.user.email
                descriptionTextField.text = selectedPosts.description
                takeImage.image = selectedImage
                actionSave.setTitle("Update Post", for: .normal)
                let deleteBarButton = UIBarButtonItem(image: UIImage(systemName: "trash.fill"), style: .plain, target: self, action: #selector(handleDelete))
                self.navigationItem.rightBarButtonItem = deleteBarButton
            }else {
                actionSave.setTitle("Add Post", for: .normal)
                self.navigationItem.rightBarButtonItem = nil
            }
                
          
        }
//print(customer)
        

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
    @IBAction func go(_ sender: Any) {
        
        if let image = takeImage.image,
           let imageData = image.jpegData(compressionQuality: 0.80),
           let description = descriptionTextField.text ,
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
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


extension HomeUserViewController : UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return carsComp.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listLogoOfCompany", for: indexPath) as! CompanyCollectionViewCell
        cell.imageOfCompany.image = UIImage(named:  carsComp[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 30, height: 30)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        return nameOfCompanyLabel.text = String(carsComp[indexPath.row])
    }
}
extension HomeUserViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
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
        takeImage.image = chosenImage
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
extension HomeUserViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
