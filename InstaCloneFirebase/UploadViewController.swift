//
//  UploadViewController.swift
//  InstaCloneFirebase
//
//  Created by Mehmet Jiyan Atalay on 10.01.2024.
//

import UIKit
import Firebase
import FirebaseStorage

class UploadViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentTextF: UITextField!
    @IBOutlet weak var uploadButtonOutlet: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageSelector))
        imageView.addGestureRecognizer(gestureRecognizer)
        
        let gestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer2)
    }
    
    @IBAction func uploadButtonClicked(_ sender: Any) {
        let storage = Storage.storage()
        let storageReference = storage.reference()
        
        let mediaFolder = storageReference.child("media")
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.1) {
            
            let uuid = UUID().uuidString
            let imageReference = mediaFolder.child("\(uuid).jpg")
            imageReference.putData(data,metadata: nil) { metadata, error in
                if error != nil {
                    self.makeAlert(title: "Error!", message: error?.localizedDescription ?? "Error!")
                } else {
                    imageReference.downloadURL { url, error2 in
                        if error2 == nil {
                            let imageUrl = url?.absoluteString
                            
                            let firestoreDatabase = Firestore.firestore()
                            
                            var firestoreReference : DocumentReference? = nil
                            
                            let firestorePost = ["imageUrl" : imageUrl!,"postedBy" : Auth.auth().currentUser!.email! , "postComment" : self.commentTextF.text! , "date" : FieldValue.serverTimestamp() , "likes" : 0] as [String : Any]
                            
                            firestoreReference = firestoreDatabase.collection("Posts").addDocument(data: firestorePost, completion: { error3 in
                                if error3 != nil {
                                    self.makeAlert(title: "Error!", message: error?.localizedDescription ?? "Error")
                                } else {
                                    self.imageView.image = UIImage(named: "select.png")
                                    self.commentTextF.text = ""
                                    self.tabBarController?.selectedIndex = 0
                                }
                            })
                        }
                    }
                }
            }
        }
    }
    
    @objc func imageSelector(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        //picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true , completion: nil)
    }
    
    func makeAlert(title : String , message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true , completion: nil)
    }
    
    @objc func hideKeyboard(){
        view.endEditing(true)
    }

}
