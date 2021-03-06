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
    
    // ------------------- Disin & localize -----------------

    @IBOutlet weak var nameOfCustomer: UILabel!{
        didSet{
            nameOfCustomer.layer.masksToBounds = true
            nameOfCustomer.layer.cornerRadius = 8
        }
    }
    @IBOutlet weak var numberOfCustomer: UILabel!{
        didSet{
            numberOfCustomer.layer.masksToBounds = true
            numberOfCustomer.layer.cornerRadius = 8
        }
    }
    @IBOutlet weak var referceButton: UIButton! {
        didSet{
            referceButton.setTitle("Refuse".localized, for: .normal)
        }
    }
    @IBOutlet weak var acceptButton: UIButton!{
        didSet{
            acceptButton.setTitle("Accept".localized, for: .normal)
        }
    }
    
    @IBOutlet weak var disin: UIStackView!{
        didSet{
            disin.layer.masksToBounds = true
            disin.layer.cornerRadius = 8
        }
    }
    var selected:Post?
    var selectedImage:UIImage?
    @IBOutlet weak var viewProblemCarLabel: UILabel!{
        didSet{
            viewProblemCarLabel.layer.masksToBounds = true
            viewProblemCarLabel.layer.cornerRadius = 8
        }
    }
    @IBOutlet weak var viewImageCar: UIImageView! {
        didSet{

//            viewImageCar.layer.masksToBounds = false
////            viewImageCar.layer.cornerRadius = 20
//            viewImageCar.layer.shadowOpacity = 10.8
//            viewImageCar.layer.shadowRadius = 50
//            viewImageCar.layer.shadowOffset = CGSize(width: 0 , height: 0)
//            viewImageCar.layer.shadowColor = UIColor.black.cgColor
            viewImageCar.layer.cornerRadius = 20
            viewImageCar.clipsToBounds = true
        }
    }
    @IBOutlet weak var locationLabel: UILabel!{
        didSet{
            locationLabel.layer.masksToBounds = true
            locationLabel.layer.cornerRadius = 8
        }
    }
    
    @IBOutlet weak var companyLabel: UILabel!{
        didSet{
            companyLabel.layer.masksToBounds = true
            companyLabel.layer.cornerRadius = 8
        }
    }
    
    
    @IBOutlet weak var disignButton: UIStackView!{
        didSet{
            disignButton.layer.cornerRadius = 17
            disignButton.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var disingLableView: UIStackView!{
        didSet{
            disingLableView.layer.cornerRadius = 20
            disingLableView.clipsToBounds = true
        }
    }
    // ------------------- Disin & localize -----------------

    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let selected = selected ,
           let selectedImage = selectedImage {
            viewProblemCarLabel.text = selected.description
            viewImageCar.image = selectedImage
            locationLabel.text = selected.location
            companyLabel.text = selected.companyName
            nameOfCustomer.text = selected.user.name
            numberOfCustomer.text = selected.user.phoneNumber
        }
        // Do any additional setup after loading the view.
        
        let backButton = UIBarButtonItem()
         backButton.title = ""
         self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    @IBAction func refece(_ sender: Any) {
        let ref = Firestore.firestore().collection("posts")
        if let selected = selected {
            Activity.showIndicator(parentView: self.view, childView: activityIndicator)
            ref.document(selected.userId).delete { error in
                if let error = error {
                    print("Error in db delete",error)
                }else {
                    let storageRef = Storage.storage().reference(withPath: "posts/\(selected.user.id)/\(selected.userId)")
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
        // segue send data between view controller

    }
    
}
