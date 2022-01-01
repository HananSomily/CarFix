//
//  ViewRequestViewController.swift
//  CarFixApp
//
//  Created by Hanan Somily on 27/12/2021.
//

import UIKit
import Firebase
class ViewRequestViewController: UIViewController {

    let activityIndicator = UIActivityIndicatorView()


    var selected:Post?
    var selectedImage:UIImage?
    @IBOutlet weak var viewProblemCarLabel: UILabel!
    
    @IBOutlet weak var viewImageCar: UIImageView!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var companyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let selected = selected ,
           let selectedImage = selectedImage {
            viewProblemCarLabel.text = selected.description
            viewImageCar.image = selectedImage
            locationLabel.text = selected.location
            companyLabel.text = selected.companyName
            
        }
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func refece(_ sender: Any) {
        let ref = Firestore.firestore().collection("posts")
        if let selected = selected {
            Activity.showIndicator(parentView: self.view, childView: activityIndicator)
            ref.document(selected.userId).delete { error in
                if let error = error {
                    print("Error in db delete",error)
                }else {
                    // Create a reference to the file to delete
                    let storageRef = Storage.storage().reference(withPath: "posts/\(selected.user.id)/\(selected.userId)")
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
    
    @IBAction func accept(_ sender: Any) {
    }
    
}
