//
//  ViewController.swift
//  Smart_Mobility
//
//  Created by Dodla,Narayan Reddy on 5/23/22.
//

import UIKit
import SwiftUI

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    struct HomeViewController: View {
        var body: some View {
            Image("App_Logo")
                .resizable()
                .scaledToFit()
        }
    }

    @IBAction func Login(_ sender: UIButton) {
        
    }
    
    @IBAction func ForgetPassword(_ sender: UIButton) {
        
    }
    
    @IBAction func SignUp(_ sender: UIButton) {
    
    }
    
}

