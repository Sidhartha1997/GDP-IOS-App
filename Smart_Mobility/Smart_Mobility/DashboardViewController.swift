//
//  DashboardViewController.swift
//  Smart_Mobility
//
//  Created by Kondr Jitendra Chowdary on 5/24/22.
//


import UIKit
import SwiftUI

class DashboardViewController: UIViewController {

    
    var body: some View {
        GeometryReader { geo in
            ZStack{
            Image("homebackground")
                .resizable()
                .scaledToFit()
                .edgesIgnoringSafeArea(.all)
                .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                .opacity(1.0)
            }
        }
    }
    
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

}
