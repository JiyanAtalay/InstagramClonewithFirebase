//
//  ViewController.swift
//  InstaCloneFirebase
//
//  Created by Mehmet Jiyan Atalay on 10.01.2024.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var emailTextF: UITextField!
    @IBOutlet weak var passwordTextF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func signinClicked(_ sender: Any) {
        if emailTextF.text != "" {
            if passwordTextF.text != "" {
                Auth.auth().signIn(withEmail: emailTextF.text!, password: passwordTextF.text!) { authdata, error in
                    if error != nil {
                        self.makeAlert(title: "Error!", message: error?.localizedDescription ?? "Error!")
                    } else {
                        self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                    }
                }
            }
            else {
                makeAlert(title: "Error!", message: "Password is Empty!")
            }
        } 
        else {
            makeAlert(title: "Error!", message: "Email is Empty!")
        }
    }
    
    @IBAction func signupClicked(_ sender: Any) {
        if emailTextF.text != "" {
            if passwordTextF.text != "" {
                Auth.auth().createUser(withEmail: emailTextF.text!, password: passwordTextF.text!) { authdata, error in
                    if error != nil {
                        self.makeAlert(title: "Error!", message: error?.localizedDescription ?? "Error!")
                    } else {
                        self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                    }
                }
            } else {
                makeAlert(title: "Error!", message: "Password is Empty!")
            }
        } else {
            makeAlert(title: "Error!", message: "Email is Empty!")
        }
        
    }
    
    func makeAlert(title : String , message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true , completion: nil)
    }
}

