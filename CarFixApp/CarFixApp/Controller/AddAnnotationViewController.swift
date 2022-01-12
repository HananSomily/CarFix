////
////  AddAnnotationViewController.swift
////  CarFixApp
////
////  Created by Hanan Somily on 12/01/2022.
////
//
import UIKit
import MapKit
import Firebase

class AddAnnotationViewController: UIViewController {

    @IBOutlet weak var nameOfWorkshop: UITextField!
    
    @IBOutlet weak var latitudeTextView: UITextView!
    
    @IBOutlet weak var longitudeTextView: UITextView!
    
    @IBOutlet weak var mapView: MKMapView!
    
    let activityIndicator = UIActivityIndicatorView()

    var wokshops = [Location]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func addlocation(_ sender: Any) {
        
//
        
        
        
    }
}
//    if let title = nameOfWorkshop.text,
//       let latitude = latitudeTextView.text,
//       let longitude = longitudeTextView.text {
//        Activity.showIndicator(parentView: self.view, childView: activityIndicator)
//        var postId = ""
////        if let selectedPost = selectedPosts {
////            postId = selectedPost.userId
////        }else {
////            postId = "\(Firebase.UUID())"
////        }
//        let storageRef = Storage.storage().reference(withPath: "location")
//        let updloadMeta = StorageMetadata.init()
//
//            storageRef.downloadURL { url, error in
//                var location = [String:Any]()
//                if let url = url {
//                    let db = Firestore.firestore()
//                    let ref = db.collection("location")
//             //       if let selectedPost = self.selectedPosts {
//                    location = [
//                            "title":title,
//                            "latitude": latitude,
//                            "longitude":longitude                        ]
////                    }else {
////                        postData = [
////                            "userId":currentUser.uid,
////                            "description":description,
////                            "companyName": companyName,
////                            "location":location,
////                            "imageUrl":url.absoluteString,
////                            "createdAt":FieldValue.serverTimestamp(),
////                            "updatedAt": FieldValue.serverTimestamp()
////                        ]
////                    }
////                    ref.document(postId).setData(postData) { error in
////                        if let error = error {
////                            print("FireStore Error",error.localizedDescription)
////                        }
//                        Activity.removeIndicator(parentView: self.view, childView: self.activityIndicator)
//                        self.navigationController?.popViewController(animated: true)
//                    }
//               // }
//            }
//        }
//    }
//    
//}
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//
