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
         //   descriptionTextField.delegate = self
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

        let ref = Firestore.firestore()

                ref.collection("users").document(Auth.auth().currentUser!.uid).getDocument { userSnapshot, error in
                         if let error = error {
                             print("ERROR user Data",error.localizedDescription)
                            print("dddddd")
                         }
                         if let userSnapshot = userSnapshot,
                            let userData = userSnapshot.data(){
                             let user = User(dict:userData)
                             print("ss\(user)")
                             self.userNameLable.text = user.name
                             self.userEmailLable.text = user.email
                             self.userPhoneLable.text = "\(user.phoneNumber)"
                         }
                }
        
            if let selectedPosts = selectedPosts ,
            let selectedImage = selectedPostImage {

//                userNameLable.text = selectedPosts.user.name
//                userEmailLable.text = selectedPosts.user.email
                descriptionTextField.text = selectedPosts.description
                takeImage.image = selectedImage
                actionSave.setTitle("Update Post", for: .normal)
//                let deleteBarButton = UIBarButtonItem(image: UIImage(systemName: "trash.fill"), style: .plain, target: self, action: #selector(handleDelete))
//                self.navigationItem.rightBarButtonItem = deleteBarButton
            }else {
                actionSave.setTitle("Add Post", for: .normal)
                self.navigationItem.rightBarButtonItem = nil
            }
       // getPosts()

          
        }
//    func getPosts() {
//        let ref = Firestore.firestore()
//                ref.collection("posts").addSnapshotListener { snapshot, error in
//                    if let error = error {
//                        print("DB ERROR Posts",error.localizedDescription)
//                    }
//                    if let snapshot = snapshot {
//                        for document in snapshot.documents {
//                            let data = document.data()
//                            if let userId = data["userId"] as? String {
//                                ref.collection("users").document(userId).getDocument { userSnapshot, error in
//                                    if let error = error {
//                                        print("ERROR user Data",error.localizedDescription)
//
//                                    }
//                                    if let userSnapshot = userSnapshot,
//                                       let userData = userSnapshot.data(){
//                                        let user = User(dict:userData)
//                                        let post = Post(dict:data,userId:document.documentID,user:user)
//                                       // self.posts.append(post)
////                                        DispatchQueue.main.async {
////                                            self.postsTableView.reloadData()
////                                        }
//
//                                    }
//                                }
//
//                            }
//                        }
//                    }
//                }
////        ref.collection("posts").order(by: "createdAt",descending: true).addSnapshotListener { snapshot, error in
////            if let error = error {
////                print("DB ERROR Posts",error.localizedDescription)
////            }
////            if let snapshot = snapshot {
////                print("POST CANGES:",snapshot.documentChanges.count)
////                snapshot.documentChanges.forEach { diff in
////                    let postData = diff.document.data()
//////                    switch diff.type {
//////                    case .added :
//////
////                        if let userId = postData["userId"] as? String {
////                            ref.collection("users").document(userId).getDocument { userSnapshot, error in
////                                if let error = error {
////                                    print("ERROR user Data",error.localizedDescription)
////
////                                }
////            }
////        }
////    }
////            }
////        }
//    }
//print(customer)
        

//@objc func handleDelete (_ sender: UIBarButtonItem) {
//    let ref = Firestore.firestore().collection("posts")
//    if let selectedPost = selectedPosts {
//        Activity.showIndicator(parentView: self.view, childView: activityIndicator)
//        ref.document(selectedPost.userId).delete { error in
//            if let error = error {
//                print("Error in db delete",error)
//            }else {
//                // Create a reference to the file to delete
//                let storageRef = Storage.storage().reference(withPath: "posts/\(selectedPost.user.id)/\(selectedPost.userId)")
//                // Delete the file
//                storageRef.delete { error in
//                    if let error = error {
//                        print("Error in storage delete",error)
//                    } else {
//                        self.activityIndicator.stopAnimating()
//                        self.navigationController?.popViewController(animated: true)
//                    }
//                }
//
//            }
//        }
//    }
//}
    @IBAction func go(_ sender: Any) {
        
        if let image = takeImage.image,
           let imageData = image.jpegData(compressionQuality: 0.80),
           let description = descriptionTextField.text ,
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
                            "createdAt":selectedPost.createdAt ?? FieldValue.serverTimestamp(),
                            "updatedAt": FieldValue.serverTimestamp()
                                ]
                    } else {
                        postData = [
                            "userId":currentUser.uid,
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
  //  }
    @IBAction func toUpdateOrDelet(_ sender: Any) {
        performSegue(withIdentifier: "toDetels", sender: self)
//        func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//            if let identifier = segue.identifier {
//                if identifier == "toDetels" {
//                    let vc = segue.destination as! DetailsViewController
//                    vc.selectedPosts = selectedPosts
//                    vc.selectedPostImage = selectedPostImage
    //                }else {
    //                    let vc = segue.destination as! DetailsViewController
    //                    vc.selectedPost = selectedPost
    //                    vc.selectedPostImage = selectedPostImage
    //                }
           // }
            
     //   }
 //   }
    }
    

    @IBAction func handleLogout(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeNavigationController") as? UITabBarController {
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
        } catch  {
            print("ERROR in signout",error.localizedDescription)
        }
        
    }
    


    
}
//}


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
        takeImage.image = chosenImage
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

//extension HomeUserViewController:UITextFieldDelegate{
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
//}
