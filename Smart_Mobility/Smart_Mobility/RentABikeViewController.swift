//
//  RentABikeViewController.swift
//  Smart_Mobility
//
//  Created by Eppalapelli,Satheesh on 5/24/22.
//
//

import UIKit
import Mixpanel
import AVFoundation
import Foundation


class RentABikeViewController: UIViewController {
    
    var timer:Timer = Timer()
    var count:Int = 0
    var timerCounting:Bool = false
    
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var resetButton: UIButton!
    
    
    @IBOutlet weak var scannerView: RentABikeView!{
        didSet {
            scannerView.delegate = self
        }
    }
    
    @IBOutlet weak var scanQRCodeButtonPressed: UIButton!{
        didSet {
            scanQRCodeButtonPressed.setTitle("Scan QR Code", for: .normal)
        }
    }

    
    var qrData: QRData? = nil {
        didSet {
            if qrData != nil {
//              self.performSegue(withIdentifier: "detailSeuge", sender: self)
                print(qrData)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        startButton.setTitleColor(UIColor.green, for: .normal)
        //        UISetups()
    }
    
    
       override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)

           if !scannerView.isRunning {
               scannerView.startScanning()
           }
       }
       
       override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)
           if !scannerView.isRunning {
               scannerView.stopScanning()
           }
       }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    @IBAction func scanQRCodeButtonPressed(_ sender: UIButton) {
        scannerView.isRunning ? scannerView.stopScanning() : scannerView.startScanning()
//        let buttonTitle = scannerView.isRunning ? "STOP" : "SCAN QR Code"
//        scanQRCodeButtonPressed.setTitle(buttonTitle, for: .normal)
        if (scannerView.isRunning)
        {
            scanQRCodeButtonPressed.setTitle("STOP", for: .normal)
        }
        else{
            scanQRCodeButtonPressed.setTitle("Scan QR Code", for: .normal)
        }
    }
    
    
    @IBAction func startRideButtonPressed(_ sender: UIButton) {
        
        if(timerCounting){
            timerCounting = false
            timer.invalidate()
            startButton.setTitle("START", for: .normal)
//            scanQRCodeButtonPressed.setTitle("STOP", for: .normal)
            startButton.setTitleColor(UIColor.green, for: .normal)
        }else{
            timerCounting = true
            startButton.setTitle("STOP", for: .normal)
            startButton.setTitleColor(UIColor.red, for: .normal)
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
        }
    }
    
    @IBAction func resetRideButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Reset Timer?", message: "Are you sure you would like to reset the Timer?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: { (_) in
            //do nothing
        }))
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (_) in
            self.count = 0
            self.timer.invalidate()
            self.timerLabel.text = self.makeTimeString(hours: 0, minutes: 0, seconds: 0)
            self.startButton.setTitle("START", for: .normal)
//            self.scanQRCodeButtonPressed.setTitle("Scan QR Code", for: .normal)
            self.startButton.setTitleColor(UIColor.green, for: .normal)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @objc func timerCounter() -> Void{
        count = count + 1
        let time = secondsToHoursMinutesSeconds(seconds: count)
        let timeString = makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
        timerLabel.text = timeString
    }
    
    func secondsToHoursMinutesSeconds(seconds: Int) -> (Int, Int, Int){
        return ((seconds / 3600), ((seconds % 3600) / 60),((seconds % 3600) % 60))
    }
    
    func makeTimeString(hours: Int, minutes: Int, seconds : Int) -> String{
        var timeString = ""
        timeString += String(format: "%02d", hours)
        timeString += " : "
        timeString += String(format: "%02d", minutes)
        timeString += " : "
        timeString += String(format: "%02d", seconds)
        return timeString
    }
    
    func presentAlert(withTitle title: String, message : String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { action in
            print("You've pressed OK Button")
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}


extension RentABikeViewController: RentABikeViewDelegate {
    func qrScanningDidStop() {
        let buttonTitle = scannerView.isRunning ? "STOP" : "Scan QR Code"
        scanQRCodeButtonPressed.setTitle(buttonTitle, for: .normal)
    }
    
    func qrScanningDidFail() {
        presentAlert(withTitle: "Error", message: "Scanning Failed. Please try again")
    }
    
    func qrScanningSucceededWithCode(_ str: String?) {
        self.qrData = QRData(codeString: str)
    }
}
