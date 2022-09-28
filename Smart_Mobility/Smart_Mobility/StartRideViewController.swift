//
//  StartRideViewController.swift
//  Smart_Mobility
//
//  Created by Dodla,Narayan Reddy on 9/27/22.
//

import UIKit

class StartRideViewController: UIViewController {

    @IBOutlet weak var TimerLabel: UILabel!
    
    @IBOutlet weak var Startbutton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    var timer:Timer = Timer()
    var count:Int = 0
    var timerCounting:Bool = false
    override func viewDidLoad()
    {
        super.viewDidLoad()
        Startbutton.setTitleColor(UIColor.green, for: .normal)
    }

        @IBAction func startTapped(_ sender: Any) {
            
            if(timerCounting)
            {
                timerCounting = false
                timer.invalidate()
                Startbutton.setTitle("START", for: .normal)
                Startbutton.setTitleColor(UIColor.green, for: .normal)
            }
            else
            {
                timerCounting = true
                Startbutton.setTitle("STOP", for: .normal)
                Startbutton.setTitleColor(UIColor.red, for: .normal)
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
            }
        }
        @IBAction func resetTapped(_ sender: Any) {
            let alert = UIAlertController(title: "Reset Timer?", message: "Are you sure you would like to reset the Timer?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: { (_) in
                //do nothing
            }))
            
            alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (_) in
                self.count = 0
                self.timer.invalidate()
                self.TimerLabel.text = self.makeTimeString(hours: 0, minutes: 0, seconds: 0)
                self.Startbutton.setTitle("START", for: .normal)
                self.Startbutton.setTitleColor(UIColor.green, for: .normal)
            }))
            
            self.present(alert, animated: true, completion: nil)
            
            
        }
            
            
        
        @objc func timerCounter() -> Void
        {
            count = count + 1
            let time = secondsToHoursMinutesSeconds(seconds: count)
            let timeString = makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
            TimerLabel.text = timeString
        }
        
        func secondsToHoursMinutesSeconds(seconds: Int) -> (Int, Int, Int)
        {
            return ((seconds / 3600), ((seconds % 3600) / 60),((seconds % 3600) % 60))
        }
        
        func makeTimeString(hours: Int, minutes: Int, seconds : Int) -> String
        {
            var timeString = ""
            timeString += String(format: "%02d", hours)
            timeString += " : "
            timeString += String(format: "%02d", minutes)
            timeString += " : "
            timeString += String(format: "%02d", seconds)
            return timeString
        }
        
        
    }
    
    // Do any additional setup after loading the view.

