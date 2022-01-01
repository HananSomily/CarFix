//
//  Alert.swift
//  CarFixApp
//
//  Created by Hanan Somily on 02/01/2022.
//

import Foundation
import UIKit
struct Alert{

    static func showAlert(strTitle: String, strMessage: String, viewController: UIViewController) {
        let myAlert = UIAlertController(title: strTitle, message: strMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        myAlert.addAction(okAction)
        viewController.present(myAlert, animated: true, completion: nil)
    }
}
