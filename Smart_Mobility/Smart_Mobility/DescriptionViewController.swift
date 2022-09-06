//
//  DescriptionViewController.swift
//  Smart_Mobility
//
//  Created by Dodla,Narayan Reddy on 9/4/22.
//

import UIKit

class DescriptionViewController: UIViewController {

    
    @IBOutlet weak var displayLabel: UILabel!
    
        var Settings : Settings?
        override func viewDidLoad() {
            super.viewDidLoad()
            
            displayLabel.text = "The Settings \((Settings?.SettingsName)!)"

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

}
