//
//  ViewRequestViewController.swift
//  CarFixApp
//
//  Created by Hanan Somily on 27/12/2021.
//

import UIKit

class ViewRequestViewController: UIViewController {

    
    
    var selected:Post?
    var selectedImage:UIImage?
    @IBOutlet weak var viewProblemCarLabel: UILabel!
    
    @IBOutlet weak var viewImageCar: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let selected = selected ,
           let selectedImage = selectedImage {
            viewProblemCarLabel.text = selected.description
            viewImageCar.image = selectedImage
            
        }
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func refece(_ sender: Any) {
    }
    
    @IBAction func accept(_ sender: Any) {
    }
    
}
