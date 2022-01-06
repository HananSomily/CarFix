//
//  UserTabBarController.swift
//  CarFixApp
//
//  Created by Hanan Somily on 05/01/2022.
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
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
