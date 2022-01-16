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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
