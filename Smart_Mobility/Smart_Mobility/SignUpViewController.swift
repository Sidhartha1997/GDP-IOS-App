//
//  SignUpViewController.swift
//  Smart_Mobility
//
//  Created by Dodla,Narayan Reddy on 5/23/22.
//

import UIKit

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
    }
}
