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
    
    @IBOutlet weak var LoginButtonPressed: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func LoginButtonPressed(_ sender: UIButton) {
        
        let email = userNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if email.isEmpty == true || password.isEmpty == true {
            
            let alert = UIAlertController(title: "Error", message: "Please enter email and password!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
            let signinview = self.storyboard?.instantiateViewController(withIdentifier: "SignInVC")
            self.present(signinview!, animated: true, completion: nil)
            self.present(alert, animated: true, completion: nil)
            
        }
        else {
            Auth.auth().signIn(withEmail: email, password: password){ [weak self] authResult, error in
                guard let error = self else {
                    let alert = UIAlertController(title: "Alert", message: "Entered Invalid Details! \(String(describing: error))", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                    
                    let homeViewController = self?.storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
                    
                    self?.view.window?.rootViewController = homeViewController
                    self?.view.window?.makeKeyAndVisible()
                    return
                }
                
                if let authResult = authResult {
                    let user = authResult.user
                    let alert = UIAlertController(title: "Alert", message: "User Logined Successfully! \(user)" , preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                    
                    // Transition to the  dashboard Page
                    self?.transitionToDashboard()
                    
                }
                else {
                    let homeViewController = self?.storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
                    
                    self?.view.window?.rootViewController = homeViewController
                    self?.view.window?.makeKeyAndVisible()
                    
                    let alert = UIAlertController(title: "Alert", message: "Entered Invalid Details!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                    
                }
            }
        }
    }
    
    func transitionToDashboard() {
        
        let dashboardViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.dashboardViewController) as? DashboardViewController
        
        view.window?.rootViewController = dashboardViewController
        view.window?.makeKeyAndVisible()
        
    }
    
}


