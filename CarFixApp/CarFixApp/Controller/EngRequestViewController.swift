//
//  EngHomeViewController.swift
//  CarFixApp
//
//  Created by Hanan Somily on 27/12/2021.
//

import UIKit
import Firebase
class EngRequestViewController: UIViewController {
    
        var posts = [Post]()
        var selectedPost:Post?
        var selectedPostImage:UIImage?
        
    @IBOutlet weak var engNameLabel: UILabel!
    @IBOutlet weak var engImage: UIImageView!
    @IBOutlet weak var engEmail: UILabel!
    @IBOutlet weak var engPhone: UILabel!
    @IBOutlet weak var postsTableView: UITableView! {
            didSet {
                postsTableView.delegate = self
                postsTableView.dataSource = self
                postsTableView.register(UINib(nibName: "EngRequestTableViewCell", bundle: nil), forCellReuseIdentifier: "problem")
            }
        }

        override func viewDidLoad() {
            super.viewDidLoad()
            //   ______________*** profile *** _______________

            let ref = Firestore.firestore()
            ref.collection("engineer").document(Auth.auth().currentUser!.uid).getDocument { userSnapshot, error in
                if let error = error {
                print("ERROR user Data",error.localizedDescription)
                             }
                             if let userSnapshot = userSnapshot,
                                let userData = userSnapshot.data(){
                                 let user = User(dict:userData)
                                 print("ss\(user)")
                               //  user.id
                                 self.engNameLabel.text = user.name
                                 self.engEmail.text = user.email
                                 self.engPhone.text = "\(user.phoneNumber)"
             }
        }
            //   ______________*** profile *** _______________

            postsTableView.layer.masksToBounds = false
            postsTableView.layer.shadowColor = UIColor.gray.cgColor
            postsTableView.layer.shadowOpacity = 0.8
            postsTableView.layer.shadowRadius = 8
            
//            if (postsTableView.contentSize.height < postsTableView.frame.size.height) {
//                //postsTableView.isScrollEnabled = false
//             }
//            else {
//               postsTableView.isScrollEnabled = true
//             }
            
            getPosts()

        }
        func getPosts() {
            let ref = Firestore.firestore()
            ref.collection("posts").order(by: "createdAt",descending: true).addSnapshotListener { snapshot, error in
                if let error = error {
                    print("DB ERROR Posts",error.localizedDescription)
                }
                if let snapshot = snapshot {
                    print("POST CANGES:",snapshot.documentChanges.count)
                    snapshot.documentChanges.forEach { diff in
                        let postData = diff.document.data()

                        switch diff.type {
                        case .added :
                            
                            if let userId = postData["userId"] as? String {
                                ref.collection("users").document(userId).getDocument { userSnapshot, error in
                                    if let error = error {
                                        print("ERROR user Data",error.localizedDescription)
                                        
                                    }
                                    print("^^^^^")
                                    if let userSnapshot = userSnapshot,
                                       let userData = userSnapshot.data(){
                                        let user = User(dict:userData)
                                        let post = Post(dict:postData,userId:diff.document.documentID,user:user)
                                        self.postsTableView.beginUpdates()
                                        if snapshot.documentChanges.count != 1 {
                                            self.posts.append(post)
                                          
                                            self.postsTableView.insertRows(at: [IndexPath(row:self.posts.count - 1,section: 0)],with: .automatic)
                                        }else {
                                            self.posts.insert(post,at:0)
                                          
                                            self.postsTableView.insertRows(at: [IndexPath(row: 0,section: 0)],with: .automatic)
                                        }
                                      
                                        self.postsTableView.endUpdates()
                                        
                                        
                                    }
                                }
                            }
                        case .modified:
                            let postId = diff.document.documentID
                            if let currentPost = self.posts.first(where: {$0.userId == postId}),
                               let updateIndex = self.posts.firstIndex(where: {$0.userId == postId}){
                                let newPost = Post(dict:postData, userId: postId, user: currentPost.user)
                                self.posts[updateIndex] = newPost
                             
                                    self.postsTableView.beginUpdates()
                                    self.postsTableView.deleteRows(at: [IndexPath(row: updateIndex,section: 0)], with: .left)
                                    self.postsTableView.insertRows(at: [IndexPath(row: updateIndex,section: 0)],with: .left)
                                    self.postsTableView.endUpdates()
                                print("%%%%%%%")
                            }
                        case .removed:
                            let postId = diff.document.documentID
                            if let deleteIndex = self.posts.firstIndex(where: {$0.userId == postId}){
                                self.posts.remove(at: deleteIndex)
                                    self.postsTableView.beginUpdates()
                                    self.postsTableView.deleteRows(at: [IndexPath(row: deleteIndex,section: 0)], with: .automatic)
                                    self.postsTableView.endUpdates()
                                print("|||||||")
                            }
                        }
                    }
                }
            }
        }

        @IBAction func handleLogout(_ sender: Any) {
            do {
                try Auth.auth().signOut()
                if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeNavigationController") as? UITabBarController {
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                }
            } catch  {
                print("ERROR in signout",error.localizedDescription)
            }
            
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if let identifier = segue.identifier {
                if identifier == "view" {
                    let vc = segue.destination as! ViewRequestViewController
                    vc.selected = selectedPost
                    vc.selectedImage = selectedPostImage
//                }else {
//                    let vc = segue.destination as! DetailsViewController
//                    vc.selectedPost = selectedPost
//                    vc.selectedPostImage = selectedPostImage
//                }
            }
            
        }
    }
    @IBAction func backTo(segue:UIStoryboardSegue){
        
    }
}
    extension EngRequestViewController: UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            print(posts,"&&^^^")
            return posts.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "problem") as! EngRequestTableViewCell
            
            cell.layer.masksToBounds = false
            cell.layer.shadowColor = UIColor.blue.cgColor
            cell.layer.shadowOpacity = 0.8
            cell.layer.shadowRadius = 50
            cell.layer.shadowOffset = CGSize(width: 0 , height: 0)
            cell.layer.borderColor = UIColor.brown.cgColor
            cell.layer.borderWidth = 1.5
            cell.layer.cornerRadius = 10
            cell.clipsToBounds = true
            
            return cell.configure(with: posts[indexPath.row])
        }
        
        
    }
    extension EngRequestViewController: UITableViewDelegate {
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 150
        }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let cell = tableView.cellForRow(at: indexPath) as! EngRequestTableViewCell
            selectedPostImage = cell.carImage.image
            selectedPost = posts[indexPath.row]
//            if let currentUser = Auth.auth().currentUser,
//               currentUser.uid == posts[indexPath.row].user.id{
                performSegue(withIdentifier: "view", sender: self)
            }
       // }
        func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
        {
            let verticalPadding: CGFloat = 8

            let maskLayer = CALayer()
            cell.layer.masksToBounds = false
                    cell.layer.borderColor = UIColor.brown.cgColor
                    cell.layer.borderWidth = 4.5
                    cell.layer.cornerRadius = 10
                    cell.clipsToBounds = true
            maskLayer.cornerRadius = 10    //if you want round edges
            maskLayer.backgroundColor = UIColor.black.cgColor
            maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: 0, dy: verticalPadding/2)
            cell.layer.mask = maskLayer
        }
    }

