//
//  SettingsViewController.swift
//  Smart_Mobility
//
//  Created by Eppalapelli,Satheesh on 9/13/22.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class SettingsViewController: UIViewController{
    
    @IBOutlet weak var signOutButtonPressed: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
        @IBAction func signOutButtonPressed(_ sender: UIButton) {
            
            let user = Auth.auth().currentUser
            
            if user != nil {
                do {
                    try Auth.auth().signOut()
                    let alert = UIAlertController(title: "Alert", message: "\(String(describing: user?.email))" , preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                    // Switch To Login Page
                    // Transition to the home screen
                    transitionToHome()
                    
                } catch let error as NSError {
                    let alert = UIAlertController(title: "Alert", message: (error as! String), preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        
        func transitionToHome() {
            
            let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
            
            view.window?.rootViewController = homeViewController
            view.window?.makeKeyAndVisible()
            
        }
    }
