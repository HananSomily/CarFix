//
//  SceneDelegate.swift
//  CarFixApp
//
//  Created by Hanan Somily on 26/12/2021.
//

import UIKit
import Firebase
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let window = window {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let currentUser = Auth.auth().currentUser {
                let db = Firestore.firestore()
                db.collection("users").document(currentUser.uid).getDocument { userSnapshot , error in
                    if let error = error {
                        print(error)
                    }
                  if let userSnapshot = userSnapshot,
                     let userData = userSnapshot.data(){
                      let user = User(dict: userData)
                     // let storybaord = UIStoryboard(name: "Main", bundle: nil)
                      if user.customer {
                    let mainTabBar = storyboard.instantiateViewController(withIdentifier: "HomeUserNavigation")
                          window.rootViewController = mainTabBar
                          window.makeKeyAndVisible()
//                      } else {
//
//                    let mainTabBar = storyboard.instantiateViewController(withIdentifier: "HomeEngNavigationBar")
//                            window.rootViewController = mainTabBar
//                            window.makeKeyAndVisible()
                      }
                  }
                }
                db.collection("engineer").document(currentUser.uid).getDocument { userSnapshot , error in
                    if let error = error {
                        print(error)
                    }
                  if let userSnapshot = userSnapshot,
                     let userData = userSnapshot.data(){
                      let user = User(dict: userData)
                     // let storybaord = UIStoryboard(name: "Main", bundle: nil)
                      if !user.customer {
                    let mainTabBar = storyboard.instantiateViewController(withIdentifier: "HomeEngNavigationBar")
                          window.rootViewController = mainTabBar
                          window.makeKeyAndVisible()
                      }
                  }
                }
            } else {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let mainTabBar = storyboard.instantiateViewController(withIdentifier: "StaringApp")
                      window.rootViewController = mainTabBar
                      window.makeKeyAndVisible()
            }
        }
    }


    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

