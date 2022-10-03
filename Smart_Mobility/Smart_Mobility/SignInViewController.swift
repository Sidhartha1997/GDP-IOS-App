//  SignInViewController.swift
//  Smart_Mobility
//
//  Created by Eppalapelli,Satheesh on 5/24/22.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class SignInViewController: UIViewController {
    
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func LoginButtonClicked(_ sender: UIButton) {
        
        let email = userNameTextField.text!
        let password = passwordTextField.text!
        
        if email.isEmpty == true || password.isEmpty == true {
            //Alert to tell the user that there was an error because they didn't fill anything in the textfields because they didn't fill anything in
            let alert = UIAlertController(title: "Error", message: "Please enter email and password!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        //
        //        else { Auth.auth().signIn(withEmail: email, password: password){authResult, error in
        //            if (error == nil) && (authResult == nil) {
        
        else { Auth.auth().signIn(withEmail: email, password: password){ [weak self] authResult, error in
            guard let strongSelf = self else {return}
            
            if let authResult = authResult {
                let user = authResult.user
                
                let alert = UIAlertController(title: "Alert", message: "User Logined Successfully!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self?.present(alert, animated: true, completion: nil)
                
                print("User signs in successfully")
                let userInfo = Auth.auth().currentUser
                let email = userInfo?.email
                
                if let error = error as? NSError {
                    switch AuthErrorCode.Code(rawValue: error as! Int) {
                    case.operationNotAllowed:
                        let alert = UIAlertController(title: "Alert", message: "Error: Indicates that email and password accounts are not enabled. Enable them in the Auth section of the Firebase console.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                        self?.present(alert, animated: true, completion: nil)
                    case.userDisabled:
                        let alert = UIAlertController(title: "Alert", message: "Error: The user account has been disabled by an administrator.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                        self?.present(alert, animated: true, completion: nil)
                    case.wrongPassword:
                        let alert = UIAlertController(title: "Alert", message: "Error: The password is invalid or the user does not have a password.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                        self?.present(alert, animated: true, completion: nil)
                    case.invalidEmail:
                        let alert = UIAlertController(title: "Alert", message: "Error: Indicates the email address is malformed.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                        self?.present(alert, animated: true, completion: nil)
                    default:
                        print("Error: \(error.localizedDescription)")
                    }
                }
                if user.isEmailVerified {
                    self?.performSegue(withIdentifier: "dashboardSegue", sender: nil)
                }
                if user != nil && !user.isEmailVerified {
                    // User is available, but their email is not verified.
                    // Let the user know by an alert, preferably with an option to re-send the verification mail.
                    self!.sendVerificationMail()
                }
            }
            else {
                let alert = UIAlertController(title: "Alert", message: "Entered Invalid Details!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self?.present(alert, animated: true, completion: nil)
                
            }
        }
        }
    }
    
    private var authUser : User? {
        return Auth.auth().currentUser
    }
    
    public func sendVerificationMail() {
        if self.authUser != nil && !self.authUser!.isEmailVerified {
            self.authUser!.sendEmailVerification(completion: { (error) in
                // Notify the user that the mail has sent or couldn't because of an error.
                let alert = UIAlertController(title: "Alert", message: "Please Verify the email id!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            })
        }
        else {
            // Either the user is not available, or the user is already verified.
            let alert = UIAlertController(title: "Alert", message: "Email is already verified or Email is not avaiable!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
