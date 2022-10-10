//
//  SignUpViewController.swift
//  Smart_Mobility
//
//  Created by Eppalapelli,Satheesh on 5/23/22.
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
    
    @IBOutlet weak var ConfirmPasswordTextField: UITextField!
    
    @IBOutlet weak var SignUpButtonPressed: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    func isPasswordValid(_ password : String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
        
    }
    
    // Check the fields and validate that the data is correct. If everything is correct, this method returns nil. Otherwise, it returns the error message
    func validateFields() -> String? {
        
        // Check that all fields are filled in
        if FirstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            LastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            PhoneNumberTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            EmailIdTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            PasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            ConfirmPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields."
        }
        
        // Check if the password is secure
        let cleanPassword = PasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanConfirmPassword = ConfirmPasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if isPasswordValid(cleanPassword) == false  && isPasswordValid(cleanConfirmPassword) == false{
            // Password isn't secure enough
            return "Please make sure your password and confirm password is at least 8 characters, contains a special character and a number."
        }
        
        return nil
    }
    
    @IBAction func SignUpButtonPressed(_ sender: UIButton) {
        
        // Validate the fields
        let error = validateFields()
        
        if error != nil {
            
            // There's something wrong with the fields, show error message
            let alert = UIAlertController(title: "Alert", message: error, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        let firstName = FirstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let lastName = LastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = EmailIdTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = ConfirmPasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let phoneNumber = PhoneNumberTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if email.isEmpty == true || password.isEmpty == true || firstName.isEmpty == true || lastName.isEmpty == true || phoneNumber.isEmpty == true {
            let alert = UIAlertController(title: "Error", message: "Please enter valid details!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
            let signupview = self.storyboard?.instantiateViewController(withIdentifier: "SignUpVC")
            self.present(signupview!, animated: true, completion: nil)
            self.present(alert, animated: true, completion: nil)
            
        } else {
            Auth.auth().createUser(withEmail: email, password: password) { authData, error in
                if(error == nil){
                    let userData = ["firstname": firstName,
                                    "lastname" : lastName,
                                    "phonenumber" : phoneNumber,
                                    "email":email,
                                    "password": password
                    ]
                    var ref: DatabaseReference!
                    ref = Database.database().reference(withPath: "smartmobility").child("users").child((authData?.user.uid)!)
                    ref.setValue(userData)
                    
                    let alert = UIAlertController(title: "Alert", message: "User Registered Successfully!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                    let db = Firestore.firestore()
                    
                    db.collection("smartmobility/users").addDocument(data: ["firstname": firstName,
                                                              "lastname" : lastName,
                                                              "phonenumber" : phoneNumber,
                                                              "email":email,
                                                              "password": password,
                                                              "uid": authData!.user.uid ]) {
                        (error) in
                        
                        if error != nil {
                            // Show error message
                            let alert = UIAlertController(title: "Alert", message: "Error saving user data", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                    
                    // Switch To Login Page
                    // Transition to the home screen
                    self.transitionToHome()
                }
                else{
                    print(error!)
                    let alert = UIAlertController(title: "Alert", message: "Entered Invalid Details \(error!)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    // Transition to the home screen
                    self.transitionToHome()
                }
            }
        }
    }
    
    func transitionToHome() {
        
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
        
    }
}
