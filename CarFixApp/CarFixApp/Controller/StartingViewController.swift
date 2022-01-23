//
//  StartingViewController.swift
//  CarFixApp
//
//  Created by Hanan Somily on 21/01/2022.
//

import UIKit

class StartingViewController: UIViewController {
    @IBOutlet weak var icon1View: UIImageView!
    @IBOutlet weak var icon11View: UIImageView!
    @IBOutlet weak var icon13View: UIImageView!
  //  @IBOutlet weak var buttonView: UIButton!
    @IBOutlet weak var icon12View: UIImageView!
    @IBOutlet weak var icon10View: UIImageView!
    @IBOutlet weak var icon9View: UIImageView!
    @IBOutlet weak var icon8View: UIImageView!
    @IBOutlet weak var icon7View: UIImageView!
    @IBOutlet weak var icon6View: UIImageView!
    @IBOutlet weak var icon5View: UIImageView!
    @IBOutlet weak var helloLabel: UILabel!
    @IBOutlet weak var icon2View: UIImageView!
    @IBOutlet weak var icon3View: UIImageView!
    @IBOutlet weak var icon4View: UIImageView!
    
    @IBOutlet weak var view1: UIView!
  //  @IBOutlet weak var view5: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view2: UIView!
    
    @IBOutlet weak var GoToMap: UIButton!
    @IBOutlet weak var goToAccount: UIButton!{
        didSet{
            goToAccount.setTitle("English".localized, for: .normal)
        }
    }
    @IBOutlet weak var goToRegester: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
       // view2.transform = CGAffineTransform.identity.translatedBy(x: -self.view.bounds.width, y: 0)
       // view5.transform = CGAffineTransform.identity.translatedBy(x: -self.view.bounds.width, y: 0)
        view3.transform = CGAffineTransform.identity.translatedBy(x: -self.view.bounds.width, y: 0)
        // Do any additional setup after loading the view.
//        UIView.animateKeyframes(withDuration: 10, delay: 1, options:.repeat , animations: {
//            self.buttonView.center.x += self.view.bounds.width
//        }, completion:nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    

        startAnimating()
    }

    func startAnimating() {
        let originalCenter = view1.center
//        UIView.animateKeyframes(withDuration: 1.5, delay: 0.0,
//           animations: {
//             //add keyframes
//           },
//           completion: nil
//         )
        UIView.animateKeyframes(withDuration: 10, delay: 1 , options: .repeat , animations: {
//            self.icon1View.center.x += self.view.bounds.width
//            self.icon2View.center.x += self.view.bounds.width
//            self.icon3View.center.x += self.view.bounds.width
//            self.icon4View.center.x += self.view.bounds.width
//            self.icon5View.center.x += self.view.bounds.width
//            self.icon6View.center.x += self.view.bounds.width
//            self.icon7View.center.x += self.view.bounds.width
//            self.icon8View.center.x += self.view.bounds.width
//            self.icon9View.center.x += self.view.bounds.width
//            self.icon10View.center.x += self.view.bounds.width
//            self.icon11View.center.x += self.view.bounds.width
//            self.icon12View.center.x += self.view.bounds.width
//            self.icon13View.center.x += self.view.bounds.width
//            self.helloLabel.center.x += self.view.bounds.width
//            self.buttonView.center.x += self.view.bounds.width
            //self.view1.center.x += self.view.bounds.width
            //self.view2.center.x += self.view.bounds.width
            self.view3.center.x += self.view.bounds.width
          //  self.view4.center.x += self.view.bounds.width
           // self.view5.center.x += self.view.bounds.width
            
            
//            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.75,
//              animations: {
//                self.view2.center.x -= self.view.bounds.width
//                self.view2.center.y -= 10.0
//              }
//            )
            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.75,
              animations: {
                self.view3.center.x += 300.0
                self.view3.center.y -= 10.0
              }
            )
            UIView.addKeyframe(withRelativeStartTime: 0.35, relativeDuration: 0.75,
              animations: {
                self.view3.center.x -= 300.0
                self.view3.center.y += 10.0
              }
            )
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5,
              animations: {
                self.GoToMap.center.x -= 40.0
                self.GoToMap.center.y += 20.0
              }
            )
            UIView.addKeyframe(withRelativeStartTime: 0.30, relativeDuration: 0.5,
              animations: {
                self.GoToMap.center.x += 30.0
                self.GoToMap.center.y -= 10.0
              }
            )
//            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5,
//              animations: {
//                self.goToAccount.center.x -= 40.0
//                self.goToAccount.center.y += 20.0
//              }
//            )
//            UIView.addKeyframe(withRelativeStartTime: 0.30, relativeDuration: 0.5,
//              animations: {
//                self.goToAccount.center.x += 30.0
//                self.goToAccount.center.y -= 10.0
//              }
//            )
//            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5,
//              animations: {
//                self.goToRegester.center.x += 30.0
//                self.goToRegester.center.y -= 10.0
//              }
//            )
//            UIView.addKeyframe(withRelativeStartTime: 0.30, relativeDuration: 0.5,
//              animations: {
//                self.goToRegester.center.x -= 40.0
//                self.goToRegester.center.y += 20.0
//              }
//            )
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5,
              animations: {
                self.icon8View.center.x += 30.0
                self.icon8View.center.y -= 10.0
              }
            )
            UIView.addKeyframe(withRelativeStartTime: 0.40, relativeDuration: 0.5,
              animations: {
                self.icon8View.center.x -= 40.0
                self.icon8View.center.y += 20.0
              }
            )
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5,
              animations: {
                self.icon1View.center.x += 30.0
                self.icon1View.center.y -= 10.0
              }
            )
            UIView.addKeyframe(withRelativeStartTime: 0.40, relativeDuration: 0.5,
              animations: {
                self.icon1View.center.x -= 40.0
                self.icon1View.center.y += 20.0
              }
            )
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5,
              animations: {
                self.icon9View.center.x += 30.0
                self.icon9View.center.y -= 10.0
              }
            )
            UIView.addKeyframe(withRelativeStartTime: 0.40, relativeDuration: 0.5,
              animations: {
                self.icon9View.center.x -= 40.0
                self.icon9View.center.y += 20.0
              }
            )
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5,
              animations: {
                self.icon7View.center.x += 30.0
                self.icon7View.center.y -= 10.0
              }
            )
            UIView.addKeyframe(withRelativeStartTime: 0.40, relativeDuration: 0.5,
              animations: {
                self.icon7View.center.x -= 40.0
                self.icon7View.center.y += 20.0
              }
            )
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5,
              animations: {
                self.icon6View.center.x += 30.0
                self.icon6View.center.y -= 10.0
              }
            )
            UIView.addKeyframe(withRelativeStartTime: 0.40, relativeDuration: 0.5,
              animations: {
                self.icon6View.center.x -= 40.0
                self.icon6View.center.y += 20.0
              }
            )
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5,
              animations: {
                self.icon2View.center.x -= 30.0
                self.icon2View.center.y += 10.0
              }
            )
            UIView.addKeyframe(withRelativeStartTime: 0.40, relativeDuration: 0.5,
              animations: {
                self.icon2View.center.x += 40.0
                self.icon2View.center.y -= 20.0
              }
            )
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5,
              animations: {
                self.icon10View.center.x -= 30.0
                self.icon10View.center.y += 10.0
              }
            )
            UIView.addKeyframe(withRelativeStartTime: 0.40, relativeDuration: 0.5,
              animations: {
                self.icon10View.center.x += 40.0
                self.icon10View.center.y -= 20.0
              }
            )
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5,
              animations: {
                self.icon3View.center.x -= 30.0
                self.icon3View.center.y += 10.0
              }
            )
            UIView.addKeyframe(withRelativeStartTime: 0.40, relativeDuration: 0.5,
              animations: {
                self.icon3View.center.x += 40.0
                self.icon3View.center.y -= 20.0
              }
            )
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5,
              animations: {
                self.icon5View.center.x -= 30.0
                self.icon5View.center.y += 10.0
              }
            )
            UIView.addKeyframe(withRelativeStartTime: 0.40, relativeDuration: 0.5,
              animations: {
                self.icon5View.center.x += 40.0
                self.icon5View.center.y -= 20.0
              }
            )
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5,
              animations: {
                self.icon11View.center.x -= 30.0
                self.icon11View.center.y += 10.0
              }
            )
            UIView.addKeyframe(withRelativeStartTime: 0.40, relativeDuration: 0.5,
              animations: {
                self.icon11View.center.x += 40.0
                self.icon11View.center.y -= 20.0
              }
            )
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5,
              animations: {
                self.icon12View.center.x -= 30.0
                self.icon12View.center.y += 10.0
              }
            )
            UIView.addKeyframe(withRelativeStartTime: 0.40, relativeDuration: 0.5,
              animations: {
                self.icon12View.center.x += 40.0
                self.icon12View.center.y -= 20.0
              }
            )
            
//            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.75,
//              animations: {
//                self.view1.center.x += 0.0
//                self.view1.center.y -= 10.0
//              }
//            )
            //            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25) {
//              self.view1.center.x += 100.0
//              self.view1.center.y -= 50.0
//              self.view1.alpha = 0.0
//            }

//            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
//              self.view2.alpha = 1.0
//              self.view2.center = originalCenter
//            }
            
        }, completion: nil)
//        UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.4) {
//          self.view1.transform = CGAffineTransform(rotationAngle: -.pi / 8)
//        }

 

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func backToStartView(segue:UIStoryboardSegue){
        
    }
    @IBAction func changeLangouge(_ sender: Any) {
        var lang = UserDefaults.standard.string(forKey: "currentLanguage")
                 if lang == "ar" {
                     Bundle.setLanguage(lang ?? "ar")
                     UIView.appearance().semanticContentAttribute = .forceRightToLeft
                    lang = "en"
                }else{
                    Bundle.setLanguage(lang ?? "en")
                    UIView.appearance().semanticContentAttribute = .forceLeftToRight
                    lang = "ar"
                }
                UserDefaults.standard.set(lang, forKey: "currentLanguage")
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let sceneDelegate = windowScene.delegate as? SceneDelegate {
                    sceneDelegate.window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "StaringApp")
      }
    }
}
