//
//  DashboardViewController.swift
//  Smart_Mobility
//
//  Created by Kondr Jitendra Chowdary on 5/24/22.
//


import UIKit
import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class DashboardViewController: UIViewController {
    
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
    
    
    @IBAction func signOutPressed(_ sender: Any) {
        let user = Auth.auth().currentUser
        
        if user != nil {
            do {
                try Auth.auth().signOut()
                // Switch To Login Page
                // Transition to the home screen
                self.transitionToHome()
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
