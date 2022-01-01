//
//  HomeUserViewController.swift
//  CarFixApp
//
//  Created by Hanan Somily on 27/12/2021.
//

import UIKit
import Firebase
import CoreLocation

class HomeUserViewController: UIViewController , CLLocationManagerDelegate {
    let imagePickerController = UIImagePickerController()

    
    
    @IBOutlet weak var malfucationTableView: UITableView!
    {
            didSet {
                malfucationTableView.delegate = self
                malfucationTableView.dataSource = self
                malfucationTableView.register(UINib(nibName: "malfunctionsCarTableViewCell", bundle: nil), forCellReuseIdentifier: "malfunctionsCell")
            }
        }
    var selectedPosts: Post?
    var posts = [Post]()

    var customer: User?
    var selectedPostImage:UIImage?
    
    var locationCity:CLLocationManager!
    
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
        malfucationTableView.reloadData()
        //    _____________  PROFIL _______________

        let ref = Firestore.firestore()
                ref.collection("users").document(Auth.auth().currentUser!.uid).getDocument { userSnapshot, error in
                         if let error = error {
                             print("ERROR user Data",error.localizedDescription)
                         }
                         if let userSnapshot = userSnapshot,
                            let userData = userSnapshot.data(){
                             let user = User(dict:userData)
                             print("+++\(user)+++")
                             self.userNameLable.text = user.name
                             self.userEmailLable.text = user.email
                             self.userPhoneLable.text = "\(user.phoneNumber)"
                            // self.userImageProfile.loadImageUsingCache(with: customer?.imageUrl)
                         }
                }

          //    _____________  PROFIL _______________
        if let selectedPosts = selectedPosts ,
        let selectedPostImage = selectedPostImage {
            cerantLocationLabel.text = selectedPosts.description
        }
        getPosts()

          
                   //  _____________ **** location **** _____________
        locationCity = CLLocationManager()
        locationCity.delegate = self
        locationCity.desiredAccuracy = kCLLocationAccuracyBest
        locationCity.requestAlwaysAuthorization()
    if CLLocationManager.locationServicesEnabled() {
        print("location enp")
        locationCity.startUpdatingLocation()
    }
    else {
        print("not found")
        }
                 //  _____________ **** location **** _____________
        }
    
    //  _____________ **** location **** _____________

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let cerentLocation = locations[0] as CLLocation
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(cerentLocation) { placemarks, error in
            if (error != nil){
                print("error")
            }
            let placemark = placemarks! as [CLPlacemark]
            if (placemark.count>0){
                let place = placemarks![0]
                let locality = place.locality ?? ""
                let area = place.administrativeArea ?? ""
                let country = place.country ?? ""
                print("locality **** \(locations)")
                print("area \(area)")
                print("country\(country)")
                self.cerantLocationLabel.text = "\(locality) , \(area)"
            }
        }
    }
    //  _____________ **** location **** _____________

    //
    // .whereField("userId", isEqualTo: selectedPosts?.user.id as Any).order(by: "createdAt").addSnapshotListener
    func getPosts() {
        let ref = Firestore.firestore()
      //  if customer?.id == selectedPosts?.userId
        
        ref.collection("posts").order(by: "createdAt",descending: true).addSnapshotListener{ snapshot, error in
            if let error = error {
                print("DB ERROR Posts",error.localizedDescription)
            }

            if let snapshot = snapshot {
                print(" CANGES:",snapshot.documentChanges.count)
                snapshot.documentChanges.forEach { diff in
                    let postData = diff.document.data()
                   // if self.customer?.id == self.selectedPosts?.userId {
                    switch diff.type {
                    case .added :
                    
                        if let userId = postData["userId"] as? String {
                            ref.collection("users").document(userId).getDocument { userSnapshot, error in
                                if let error = error {
                                    print("ERROR user Data",error.localizedDescription)

                                }
                                if let userSnapshot = userSnapshot,
                                   let userData = userSnapshot.data(){
                                    let user = User(dict:userData)
                        let post = Post(dict:postData,userId:diff.document.documentID,user:user)
                                    self.malfucationTableView.beginUpdates()
                                    if snapshot.documentChanges.count != 1 {
                                        self.posts.append(post)

                                        self.malfucationTableView.insertRows(at: [IndexPath(row:self.posts.count - 1,section: 0)],with: .automatic)
                                    }else {
                                        self.posts.insert(post,at:0)

                                        self.malfucationTableView.insertRows(at: [IndexPath(row: 0,section: 0)],with: .automatic)
                                    }

                                    self.malfucationTableView.endUpdates()
                                }
                            }
                        }
                    case .modified:
                    let postId = diff.document.documentID
                    if let currentPost = self.posts.first(where: {$0.userId == postId}),
                       let updateIndex = self.posts.firstIndex(where: {$0.userId == postId}){
                        let newPost = Post(dict:postData, userId: postId, user: currentPost.user)
                        self.posts[updateIndex] = newPost
                     print(newPost,"NEW+++")
                            self.malfucationTableView.beginUpdates()
                            self.malfucationTableView.deleteRows(at: [IndexPath(row: updateIndex,section: 0)], with: .left)
                            self.malfucationTableView.insertRows(at: [IndexPath(row: updateIndex,section: 0)],with: .left)
                            self.malfucationTableView.endUpdates()
                                }
                    case .removed:
                        let postId = diff.document.documentID
                        if let deleteIndex = self.posts.firstIndex(where: {$0.userId == postId}){

                            self.posts.remove(at: deleteIndex)
                                self.malfucationTableView.beginUpdates()
                                self.malfucationTableView.deleteRows(at: [IndexPath(row: deleteIndex,section: 0)], with: .automatic)
                                self.malfucationTableView.endUpdates()
                            print("|||||||")
                            }
                        }
                      }
               // }
                   }
                }
             }
    //}
    
    @IBAction func go(_ sender: Any) {
        
        if let image = takeImage.image,
           let imageData = image.jpegData(compressionQuality: 0.75),
           let description = descriptionTextField.text,
           let location = cerantLocationLabel.text,
           let companyName = nameOfCompanyLabel.text ,
           let currentUser = Auth.auth().currentUser {
            Activity.showIndicator(parentView: self.view, childView: activityIndicator)
            var postId = ""
            if let selectedPost = selectedPosts {
                postId = selectedPost.userId
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
                                "companyName": companyName,
                                "location":location,
                                "imageUrl":url.absoluteString,
                                "createdAt":selectedPost.createdAt ?? FieldValue.serverTimestamp(),
                                "updatedAt": FieldValue.serverTimestamp()
                            ]
                        }else {
                            postData = [
                                "userId":currentUser.uid,
                                "description":description,
                                "companyName": companyName,
                                "location":location,
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
        
    }

   //}
    @IBAction func toUpdateOrDelet(_ sender: Any) {
//        selectedPosts?.description = descriptionTextField.text!
//        selectedPostImage = takeImage.image
//        print(selectedPosts,"***")
//        func configure(with post:Post) {
//            cerantLocationLabel.text = post.description
//            takeImage.loadImageUsingCache(with: post.imageUrl)
//        }

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "toDetels" {
                let vc = segue.destination as! DetailsViewController
                vc.selectedPosts = selectedPosts
                vc.selectedPostImage = selectedPostImage
            }
        }
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

extension HomeUserViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "malfunctionsCell") as! malfunctionsCarTableViewCell
        return cell.configure(with: posts[indexPath.row])
    }
    
    
}
extension HomeUserViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! malfunctionsCarTableViewCell
        selectedPostImage = cell.malfunctionImage.image
        selectedPosts = posts[indexPath.row]
//            if let currentUser = Auth.auth().currentUser,
//               currentUser.uid == posts[indexPath.row].user.id{
            performSegue(withIdentifier: "toDetels", sender: self)
        }
   // }
}
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

