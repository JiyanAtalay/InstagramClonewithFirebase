//
//  FeedCell.swift
//  InstaCloneFirebase
//
//  Created by Mehmet Jiyan Atalay on 12.01.2024.
//

import UIKit
import Firebase

class FeedCell: UITableViewCell {

    
    @IBOutlet weak var useremailLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var userimageView: UIImageView!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var documentidLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func likeButtonClicked(_ sender: Any) {
        let fireStoreDatabase = Firestore.firestore()
        
        if let likeCount = Int(likeCountLabel.text!) {
            let likeStore = ["likes" : likeCount + 1] as [String : Any]
            
            fireStoreDatabase.collection("Posts").document(documentidLabel.text!).setData(likeStore, merge: true)
        }
        
    }
}
