////
////  SettingsViewController.swift
////  Smart_Mobility
////
////  Created by Eppalapelli,Satheesh on 9/13/22.
////
//
//import UIKit
//
//class Settings{
//    var settingsName : String?
//
//    init(setName: String){
//        self.settingsName = setName
//    }
//}
//
//class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
//     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//         //returns an int that shows number of rows
//
//         return settingsArray.count
//
//      }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        //returns a cell
//        //Create a cell with a cell name and the index path
//        let cell = TableViewOutlet.dequeueReusableCell(withIdentifier: "sectionCell", for: indexPath)
//        //Assign the data into the cell
//        cell.textLabel?.text = settingsArray[indexPath.row].settingsName
//        return cell
//   }
//
//
//    @IBOutlet weak var TableViewOutlet: UITableView!
//
//    var settingsArray = [Settings]()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
////        self.title = "Settings"
//        //Assign the number of rows
//        TableViewOutlet.delegate = self
//        //Assign the datasource
//        TableViewOutlet.dataSource = self
//
//        let s1 = Settings(setName: "Account Settings")
//        settingsArray.append(s1)
//
//        let s2 = Settings(setName: "Notifications")
//        settingsArray.append(s2)
//
//        let s3 = Settings(setName: "Wallet")
//        settingsArray.append(s3)
//
//        let s4 = Settings(setName: "Need Help")
//        settingsArray.append(s4)
//        
//        let s5 = Settings(setName: "Report")
//        settingsArray.append(s5)
//
//        let s6 = Settings(setName: "Refer")
//        settingsArray.append(s6)
//
//}
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let transition = segue.identifier
//        if transition == "SettingsDescription"{
//            let destination = segue.destination as!  SettingsResultViewController
//            //Assigning product to the destination
//            destination.settings = settingsArray[(TableViewOutlet.indexPathForSelectedRow?.row)!]
//        }
//    }
//
//
//}
//
//
//
