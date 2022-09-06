//
//  SETTINGSViewController.swift
//  Smart_Mobility
//
//  Created by Dodla,Narayan Reddy on 9/4/22.
//

import UIKit

class Settings{
    var SettingsName : String?
    
    init(SetName: String){
        self.SettingsName = "SetName"
    }
}


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //returns an int that shows number of rows
        
        return SettingsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //returns a cell
        //Create a cell with a cell name and the index path
        let cell = TableViewOutlet.dequeueReusableCell(withIdentifier: "SettingsDescription", for: indexPath)
        //Assign the data into the cell
        cell.textLabel?.text = SettingsArray[indexPath.row].SettingsName
        return cell
    }
    

    @IBOutlet weak var TableViewOutlet: UITableView!
    
    var SettingsArray = [Settings]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //Assign the number of rows
        TableViewOutlet.delegate = self
        //Assign the datasource
        TableViewOutlet.dataSource = self
        
        let s1 = Settings(SetName: "MacBookAir")
        SettingsArray.append(s1)
        
        let s2 = Settings(SetName: "iPhone")
        SettingsArray.append(s2)
        
        let s3 = Settings(SetName: "iPad")
        SettingsArray.append(s3)
    
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let transition = segue.identifier
        if transition == "SettingsDescription"{
            let destination = segue.destination as!  DescriptionViewController
            
            //Assigning product to the destination
            destination.Settings = SettingsArray[(TableViewOutlet.indexPathForSelectedRow?.row)!]
        }
    }


}





































//import UIKit

//class ViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     //   <#code#>
 //   }
    
    
    
    
 //   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
 //   }
    
    
    
  


//    @IBOutlet weak var settingTableView: UITableView!
    
  //  override func viewDidLoad() {
   //     super.viewDidLoad()
        
    //    settingTableView.delegate = self
     //   settingTableView.dataSource = self
    
       
 //  }
    
//}


//extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    
//extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
 //  func tableView( _ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
     //  print("You selected one")
//  }
   
 //   func tableView(_tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
       // return 8
 //  }
    
 //   func tableView(_tableView: UITableView,cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 //     let cell = settingTableView.dequeueReusableCell(withIdentifier:"tableCell", for:indexPath)
    //   cell.textLabel?.text="I am the cell"
  //    return cell
// }
//}
//}
