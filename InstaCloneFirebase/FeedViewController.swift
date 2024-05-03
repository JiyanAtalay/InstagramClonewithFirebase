//
//  FeedViewController.swift
//  InstaCloneFirebase
//
//  Created by Mehmet Jiyan Atalay on 10.01.2024.
//

import UIKit
import Firebase
import SDWebImage

class FeedViewController: UIViewController , UITableViewDelegate , UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    
    var useremailArray = [String]()
    var usercommentArray = [String]()
    var likeArray = [Int]()
    var userImageArray = [String]()
    var documentIdArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getDataFromFireStore()
    }
    
    func getDataFromFireStore() {
        let fireStoreDatabase = Firestore.firestore()
        
        fireStoreDatabase.collection("Posts").order(by: "date", descending: true).addSnapshotListener { snapshot, error in
            if error != nil {
                self.makeAlert(title: "Error!", message: error?.localizedDescription ?? "Error!")
            } else {
                if snapshot?.isEmpty != true && snapshot != nil{
                    self.likeArray.removeAll(keepingCapacity: false)
                    self.useremailArray.removeAll(keepingCapacity: false)
                    self.usercommentArray.removeAll(keepingCapacity: false)
                    self.userImageArray.removeAll(keepingCapacity: false)
                    self.documentIdArray.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents {
                        let documentId = document.documentID
                        self.documentIdArray.append(documentId)
                        
                        if let postedBy = document.get("postedBy") as? String {
                            if let postComment = document.get("postComment") as? String {
                                if let likes = document.get("likes") as? Int {
                                    if let imageUrl = document.get("imageUrl") as? String {
                                        self.useremailArray.append(postedBy)
                                        self.usercommentArray.append(postComment)
                                        self.likeArray.append(likes)
                                        self.userImageArray.append(imageUrl)
                                    }
                                }
                            }
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return useremailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        cell.commentLabel.text = usercommentArray[indexPath.row]
        cell.likeCountLabel.text = String(likeArray[indexPath.row])
        cell.useremailLabel.text = useremailArray[indexPath.row]
        cell.documentidLabel.text = documentIdArray[indexPath.row]
        cell.userimageView.sd_setImage(with: URL(string: self.userImageArray[indexPath.row]),placeholderImage: UIImage(named: "select.png"))
        
        return cell
    }
    
    func makeAlert(title : String , message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true , completion: nil)
    }
}
