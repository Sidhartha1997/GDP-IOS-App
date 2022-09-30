//
//  SignInViewController.swift
//  Smart_Mobility
//
//  Created by Kondr Jitendra Chowdary on 5/24/22.
//

import UIKit
import Firebase
import FirebaseAuth

class SignInViewController: UIViewController {
    
    @IBOutlet weak var userNameTextField: UITextField!
    
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    @IBAction func LoginButtonClicked(_ sender: UIButton) {
        
        let email = userNameTextField.text!
        let password = passwordTextField.text!
        
        if email == "" || password == "" {
            //Alert to tell the user that there was an error because they didn't fill anything in the textfields because they didn't fill anything in
            let alert = UIAlertController(title: "Error", message: "Please enter email and password!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            //            print("login")
        }
        else { Auth.auth().signIn(withEmail: email, password: password){authResult, error in
            if (error == nil) && (authResult == nil) {
                let alert = UIAlertController(title: "Alert", message: "User Logined Successfully!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                if let error = error as? NSError {
                    switch AuthErrorCode.Code(rawValue: error as! Int) {
                    case.operationNotAllowed:
                        let alert = UIAlertController(title: "Alert", message: "Error: Indicates that email and password accounts are not enabled. Enable them in the Auth section of the Firebase console.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    case.userDisabled:
                        let alert = UIAlertController(title: "Alert", message: "Error: The user account has been disabled by an administrator.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    case.wrongPassword:
                        let alert = UIAlertController(title: "Alert", message: "Error: The password is invalid or the user does not have a password.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    case.invalidEmail:
                        let alert = UIAlertController(title: "Alert", message: "Error: Indicates the email address is malformed.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    default:
                        print("Error: \(error.localizedDescription)")
                    }
                }
                else {
                    print("User signs in successfully")
                    let userInfo = Auth.auth().currentUser
                    let email = userInfo?.email
                }
                
            }
            else{
                let alert = UIAlertController(title: "Alert", message: "Entered Invalid Details!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        }
    }
    
}

