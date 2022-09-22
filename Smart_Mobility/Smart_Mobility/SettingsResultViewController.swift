//
//ResultViewController.swift
//Smart_Mobility
//
//Created; by Eppalapelli,Satheesh on 9/15/22.


import UIKit


class SettingsResultViewController: UIViewController {
    
    
    @IBOutlet weak var displayLabel: UILabel!
    
    var settings : Settings?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayLabel.text = "\((settings?.settingsName)!)"
        
        // Do any additional setup after loading the view.
    }
    
    
    
    /*
     MARK: - Navigation
     In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
