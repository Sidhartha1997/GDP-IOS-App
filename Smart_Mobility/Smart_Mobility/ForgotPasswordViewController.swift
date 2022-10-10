//
//  ForgotPasswordViewController.swift
//  Smart_Mobility
//
//  Created by Dodla,Narayan Reddy on 5/23/22.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var EmailIdTextField: UITextField!
    
    @IBOutlet weak var forgotPasswordButtonPressed: UIButton!
    
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
    
    @IBAction func forgotPasswordButtonPressed(_ sender: Any) {
        
        let email = EmailIdTextField.text!
        
        guard  email != nil else { return }
        
        // Sign in a user with Firebase using the email provider. Callback with FIRUser, Error with _code = FIRAuthErrorCode
        Auth.auth().sendPasswordReset(withEmail: email, completion: { (error) in
            if error != nil{
                let resetFailedAlert = UIAlertController(title: "Reset Failed", message: "Error: \(String(describing: error?.localizedDescription))", preferredStyle: .alert)
                resetFailedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(resetFailedAlert, animated: true, completion: nil)
            }else {
                let resetEmailSentAlert = UIAlertController(title: "Reset email sent successfully", message: "Check your email", preferredStyle: .alert)
                resetEmailSentAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(resetEmailSentAlert, animated: true, completion: nil)
                
                self.transitionToHome()
            }
        })
    }
    
    func transitionToHome() {
        
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
        
    }
}

