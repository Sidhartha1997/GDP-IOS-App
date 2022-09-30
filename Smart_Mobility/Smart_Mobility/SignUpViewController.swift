//
//  SignUpViewController.swift
//  Smart_Mobility
//
//  Created by Dodla,Narayan Reddy on 5/23/22.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import Firebase
import FirebaseAuth

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
        
        if email == "" || password == "" || firstName == "" || lastName == "" || phoneNumber == "" {
            let alert = UIAlertController(title: "Error", message: "Please enter valid details!", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        } else {
            Auth.auth().createUser(withEmail: email, password: password, completion:{ authData, error  in
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

                    
                    ref = Database.database().reference(withPath: "smartmobility").child("user").child((authData?.user.uid)!)
                    ref.setValue(userData)
                    
                    // Switch To Dashboard Page
//                    performSegue(withIdentifier: "dashboard", sender: self)
                }
                else{
                    print(error!)
                    let alert = UIAlertController(title: "Alert", message: "Entered Invalid Details!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }
    }
    
    
}
