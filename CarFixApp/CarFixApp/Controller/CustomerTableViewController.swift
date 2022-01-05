//
//  CustomerTableViewController.swift
//  CarFixApp
//
//  Created by Hanan Somily on 05/01/2022.
//

import UIKit
import Firebase
class CustomerTableViewController: UIViewController {

    var selectedPosts: Post?
    var posts = [Post]()

    var customer: User?
    var selectedPostImage:UIImage?
    

    @IBOutlet weak var malfucationTableView: UITableView!
    {
            didSet {
                malfucationTableView.delegate = self
                malfucationTableView.dataSource = self
                malfucationTableView.register(UINib(nibName: "malfunctionsCarTableViewCell", bundle: nil), forCellReuseIdentifier: "malfunctionsCell")
            }
        }
    override func viewDidLoad() {
        super.viewDidLoad()

        malfucationTableView.reloadData()
        
        malfucationTableView.layer.masksToBounds = false
        malfucationTableView.layer.shadowColor = UIColor.brown.cgColor
        malfucationTableView.layer.shadowOpacity = 0.8
        malfucationTableView.layer.shadowRadius = 8

        
        let backButton = UIBarButtonItem()
         backButton.title = ""
         self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
       // malfucationTableView.frame = malfucationTableView.frame.inset(by: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))


        // Do any additional setup after loading the view.
        getPosts()
    }
    

    func getPosts() {
        let ref = Firestore.firestore()
      //  if customer?.id == selectedPosts?.userId
        //.whereField("userId", isEqualTo: Auth.auth().currentUser!.uid)
        //.order(by: "createdAt",descending: true).
        ref.collection("posts").whereField("userId", isEqualTo: Auth.auth().currentUser!.uid).addSnapshotListener{ snapshot, error in
            if let error = error {
                print("DB ERROR Posts",error.localizedDescription)
            }

            if let snapshot = snapshot {
                print(" CANGES:",snapshot.documentChanges.count)
                snapshot.documentChanges.forEach { diff in
                    let postData = diff.document.data()
                   // if self.customer?.id == self.selectedPosts?.userId {
                    switch diff.type {
                    case .added :
                    
                        if let userId = postData["userId"] as? String {
                            ref.collection("users").document(userId).getDocument { userSnapshot, error in
                                if let error = error {
                                    print("ERROR user Data",error.localizedDescription)

                                }
                                if let userSnapshot = userSnapshot,
                                   let userData = userSnapshot.data(){
                                    let user = User(dict:userData)
                        let post = Post(dict:postData,userId:diff.document.documentID,user:user)
                                    self.malfucationTableView.beginUpdates()
                                    if snapshot.documentChanges.count != 1 {
                                        self.posts.append(post)

                                        self.malfucationTableView.insertRows(at: [IndexPath(row:self.posts.count - 1,section: 0)],with: .automatic)
                                    }else {
                                        self.posts.insert(post,at:0)

                                        self.malfucationTableView.insertRows(at: [IndexPath(row: 0,section: 0)],with: .automatic)
                                    }

                                    self.malfucationTableView.endUpdates()
                                }
                            }
                            print("$$$$$")
                        }
                    case .modified:
                    let postId = diff.document.documentID
                    if let currentPost = self.posts.first(where: {$0.userId == postId}),
                       let updateIndex = self.posts.firstIndex(where: {$0.userId == postId}){
                        let newPost = Post(dict:postData, userId: postId, user: currentPost.user)
                        self.posts[updateIndex] = newPost
                     print(newPost,"NEW+++")
                            self.malfucationTableView.beginUpdates()
                            self.malfucationTableView.deleteRows(at: [IndexPath(row: updateIndex,section: 0)], with: .left)
                            self.malfucationTableView.insertRows(at: [IndexPath(row: updateIndex,section: 0)],with: .left)
                            self.malfucationTableView.endUpdates()
                        print("%%%%%%%")
                                }
                    case .removed:
                        let postId = diff.document.documentID
                        if let deleteIndex = self.posts.firstIndex(where: {$0.userId == postId}){

                            self.posts.remove(at: deleteIndex)
                                self.malfucationTableView.beginUpdates()
                                self.malfucationTableView.deleteRows(at: [IndexPath(row: deleteIndex,section: 0)], with: .automatic)
                                self.malfucationTableView.endUpdates()
                            print("|||||||")
                            }
                        }
                      }
               // }
                   }
                }
             }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "toDetels" {
                let vc = segue.destination as! DetailsViewController
                vc.selectedPosts = selectedPosts
                vc.selectedPostImage = selectedPostImage
            }
        }
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
extension CustomerTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("*****" , posts)
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "malfunctionsCell") as! malfunctionsCarTableViewCell
        
//        let whiteRoundedView : UIView = UIView(frame: CGRect(x: 10, y: 8, width: self.view.frame.size.width - 20, height: 149))

        
//        cell.layer.masksToBounds = false
//        cell.layer.shadowColor = UIColor.blue.cgColor
//        cell.layer.shadowOpacity = 0.8
//        cell.layer.shadowRadius = 50
//        cell.layer.shadowOffset = CGSize(width: 0 , height: 0)
//        cell.layer.borderColor = UIColor.brown.cgColor
//        cell.layer.borderWidth = 1.5
//        cell.layer.cornerRadius = 10
//        cell.clipsToBounds = true
//        cell.contentView.addSubview(whiteRoundedView)
//            cell.contentView.sendSubviewToBack(whiteRoundedView)


        return cell.configure(with: posts[indexPath.row])
    }
    
    
    
    
    
    
}
extension CustomerTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! malfunctionsCarTableViewCell
        selectedPostImage = cell.malfunctionImage.image
        selectedPosts = posts[indexPath.row]
//            if let currentUser = Auth.auth().currentUser,
//               currentUser.uid == posts[indexPath.row].user.id{
            performSegue(withIdentifier: "toDetels", sender: self)
        }
   // }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        let verticalPadding: CGFloat = 8

        let maskLayer = CALayer()
        cell.layer.masksToBounds = false
//                cell.layer.shadowColor = UIColor.blue.cgColor
//                cell.layer.shadowOpacity = 0.8
//                cell.layer.shadowRadius = 50
//                cell.layer.shadowOffset = CGSize(width: 0 , height: 0)
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

