//
//  UserTabBarController.swift
//  CarFixApp
//
//  Created by Hanan Somily on 11/01/2022.
//

import UIKit

class UserTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.items?[0].title = ""
        //"user".localized
        tabBar.items?[1].title = ""
        //"Map".localized
        
        // Do any additional setup after loading the view.
    }
    

}
