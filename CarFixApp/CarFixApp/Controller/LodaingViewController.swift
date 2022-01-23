//
//  LodaingViewController.swift
//  CarFixApp
//
//  Created by Hanan Somily on 16/01/2022.
//

import UIKit
import NVActivityIndicatorView
class LodaingViewController: UIViewController {

    @IBOutlet weak var loadingNVA: NVActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()

        loadingNVA.startAnimating()
        
        // Do any additional setup after loading the view.
    }
    
}
