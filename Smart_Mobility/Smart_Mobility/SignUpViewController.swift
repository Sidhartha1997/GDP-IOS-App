//
//  SignUpViewController.swift
//  Smart_Mobility
//
//  Created by Dodla,Narayan Reddy on 5/23/22.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var FirstNameTextField: UITextField!
    
    
    @IBOutlet weak var LastNameTextField: UITextField!
    
    
    @IBOutlet weak var PhoneNumberTextField: UITextField!
    
    
    @IBOutlet weak var EmailIdTextField: UITextField!
    
    
    @IBOutlet weak var PasswordTextField: UITextField!
    
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    
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
    
    @IBAction func SignUp(_ sender: UIButton) {
        let email = EmailIdTextField.text!
        let password = confirmPasswordTextField.text!
        let firstName = FirstNameTextField.text!
        let lastName = LastNameTextField.text!
        let phoneNumber = PhoneNumberTextField.text!
        
        if email.isEmpty == true || password.isEmpty == true || firstName.isEmpty == true || lastName.isEmpty == true || phoneNumber.isEmpty == true {
            let alert = UIAlertController(title: "Error", message: "Please enter valid details!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        } else {
            //            Auth.auth().createUser(withEmail: email, password: password, completion:{ authData, error  in
            Auth.auth().createUser(withEmail: email, password: password) { authData, error in
                if(error == nil){
                    let alert = UIAlertController(title: "Alert", message: "User Registered Successfully!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    let userData = ["firstname": firstName,
                                    "lastname" : lastName,
                                    "phonenumber" : phoneNumber,
                                    "email":email,
                                    "password": password
                    ]
                    var ref: DatabaseReference!
                    //                    ref = Database.database().reference().root
                    //                    ref.child("users").child((authData?.user.uid)!).setValue(userData)
                    
                    
                    ref = Database.database().reference(withPath: "smartmobility").child("user").child((authData?.user.uid)!)
                    ref.setValue(userData)
                    
                    self.sendVerificationMail()
                    // Switch To Dashboard Page
                    //                    performSegue(withIdentifier: "dashboard", sender: self)
                }
                else{
                    print(error!)
                    let alert = UIAlertController(title: "Alert", message: "Entered Invalid Details!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
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
