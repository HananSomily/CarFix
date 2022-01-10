//
//  HomeUserViewController.swift
//  CarFixApp
//
//  Created by Hanan Somily on 27/12/2021.
//

import UIKit
import Firebase
import CoreLocation
import Foundation

class HomeUserViewController: UIViewController , CLLocationManagerDelegate {
    let imagePickerController = UIImagePickerController()

    // ------------------- localize -----------------

    
    @IBOutlet weak var mapViewButton: UIButton!{
        didSet{
            mapViewButton.setTitle("View Map".localized, for: .normal)
        }
    }
    
    @IBOutlet weak var viewButton: UIButton!{
        didSet{
            viewButton.setTitle("view".localized, for: .normal)
        }
    }
    
    @IBOutlet weak var addButton: UIButton!{
        didSet{
            addButton.setTitle("send".localized, for: .normal)
        }
    }
    
    // ------------------- localize -----------------

    var selectedPosts: Post?
    var posts = [Post]()

    var customer: User?
    var selectedPostImage:UIImage?
    
    var locationCity:CLLocationManager!
    
    @IBOutlet weak var userNameLable: UILabel!
    @IBOutlet weak var userImageProfile: UIImageView! {
        didSet{
            userImageProfile.layer.shadowOpacity = 0.8
            userImageProfile.layer.shadowRadius = 50
            userImageProfile.layer.shadowOffset = CGSize(width: 0 , height: 0)
            userImageProfile.layer.cornerRadius = 10
            userImageProfile.clipsToBounds = true
        }
    }
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
    @IBOutlet weak var cerantLocationLabel: UILabel! {
        didSet{
            cerantLocationLabel.text = "location"
        }
    }
   // @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var descriptionTextField: UITextField! {
        didSet{
            descriptionTextField.layer.cornerRadius = 20
            descriptionTextField.clipsToBounds = true        }
    }
    
    @IBOutlet weak var viewDisin: UIView!{
        didSet{
            viewDisin.layer.masksToBounds = false
            viewDisin.layer.shadowOpacity = 0.8
            viewDisin.layer.shadowRadius = 50
            viewDisin.layer.shadowOffset = CGSize(width: 0 , height: 0)
            viewDisin.layer.cornerRadius = 10
            viewDisin.clipsToBounds = true
        }
    }
    @IBOutlet weak var nameOfCompanyLabel: UILabel!{
        didSet{
            nameOfCompanyLabel.text = "plese select"
        }
    }
    @IBOutlet weak var takeImage: UIImageView! {
        didSet{
            
            takeImage.layer.cornerRadius = 20
            takeImage.clipsToBounds = true
            takeImage.isUserInteractionEnabled = true
            let tabGesture = UITapGestureRecognizer(target: self, action: #selector(selectImage))
            takeImage.addGestureRecognizer(tabGesture)
        }
    }
    let activityIndicator = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
      //  malfucationTableView.reloadData()
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
                tap.cancelsTouchesInView = false
                view.addGestureRecognizer(tap)
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
                             self.userImageProfile.loadImageUsingCache(with: user.imageUrl)
                         }
                }

          //    _____________  PROFIL _______________
        if let selectedPosts = selectedPosts ,
        let selectedPostImage = selectedPostImage {
            cerantLocationLabel.text = selectedPosts.description
        }
       // getPosts()

          
               //  _____________ **** location **** _____________
        locationCity = CLLocationManager()
        locationCity.requestAlwaysAuthorization()
        locationCity.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationCity.delegate = self
            locationCity.desiredAccuracy = kCLLocationAccuracyBest

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
//        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
//           print("****locations = \(locValue.latitude) \(locValue.longitude)")
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
//                let y = place.location?.altitude
                print("locality **** \(locations)")
                print("area \(area)")
                print("country\(country)")
                self.cerantLocationLabel.text = "\(locality) , \(area)"
            }
        }
    }
    //  _____________ **** location **** _____________

    
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
//toDetels
    ///        selectedPosts?.description = descriptionTextField.text!
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


extension HomeUserViewController : UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return carsComp.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listLogoOfCompany", for: indexPath) as! CompanyCollectionViewCell
        cell.imageOfCompany.image = UIImage(named:  carsComp[indexPath.row])
        cell.layer.cornerRadius = 20
        cell.clipsToBounds = true
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 30, height: 30)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        return nameOfCompanyLabel.text = String(carsComp[indexPath.row]).localized
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

