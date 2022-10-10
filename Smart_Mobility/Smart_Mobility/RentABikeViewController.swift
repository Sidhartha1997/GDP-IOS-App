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


class RentABikeViewController: UIViewController {
    
    
    var captureDevice: AVCaptureDevice?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var captureSession: AVCaptureSession?
    
    var timer:Timer = Timer()
    var count:Int = 0
    var timerCounting:Bool = false
    
   
    @IBOutlet weak var codeFrameView: UIView!
    
    @IBOutlet weak var scanQRCodeButtonPressed: UIButton!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var resetButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        startButton.setTitleColor(UIColor.green, for: .normal)
        UISetups()
        captureDeviceSetup()
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func scanBikeQRCodeButtonPressed(_ sender: UIButton) {
        
        captureDevice = AVCaptureDevice.default(for: .video)
        if let captureDevice = captureDevice {
            do {
                let input = try AVCaptureDeviceInput(device: captureDevice)
                
                captureSession = AVCaptureSession()
                guard let captureSession = captureSession else {
                    return
                }
                captureSession.addInput(input)
                
                let captureMetaDataOutput = AVCaptureMetadataOutput()
                // captureMetaDataOutput.rectOfInterest = codeFrameView.frame
                captureSession.addOutput(captureMetaDataOutput)
                
                captureMetaDataOutput.setMetadataObjectsDelegate(self, queue: .main)
                captureMetaDataOutput.metadataObjectTypes = [.code128, .qr, .ean13, .ean8, .code39]
                captureSession.startRunning()
                
                
                self.videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                self.videoPreviewLayer?.videoGravity = .resizeAspectFill
                self.videoPreviewLayer?.frame = view.layer.bounds
                if let videoPreviewLayer = videoPreviewLayer {
                    view.layer.insertSublayer(videoPreviewLayer, at: UInt32(0))
                    let darkLayerView = DarkScannerLayerView(frame: self.view.frame)
                    darkLayerView.delegate = self
                    view.insertSubview(darkLayerView, at: 1)
                }
            } catch {
                debugPrint("Error Device Input")
            }
        }
    }
    
    func captureDeviceSetup() {
        captureDevice = AVCaptureDevice.default(for: .video)
        if let captureDevice = captureDevice {
            do {
                let input = try AVCaptureDeviceInput(device: captureDevice)
                
                captureSession = AVCaptureSession()
                guard let captureSession = captureSession else {
                    return
                }
                captureSession.addInput(input)
                
                let captureMetaDataOutput = AVCaptureMetadataOutput()
                // captureMetaDataOutput.rectOfInterest = codeFrameView.frame
                captureSession.addOutput(captureMetaDataOutput)
                
                captureMetaDataOutput.setMetadataObjectsDelegate(self, queue: .main)
                captureMetaDataOutput.metadataObjectTypes = [.code128, .qr, .ean13, .ean8, .code39]
                captureSession.startRunning()
                
                self.videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                self.videoPreviewLayer?.videoGravity = .resizeAspectFill
                self.videoPreviewLayer?.frame = view.layer.bounds
                if let videoPreviewLayer = videoPreviewLayer {
                    view.layer.insertSublayer(videoPreviewLayer, at: UInt32(0))
                    let darkLayerView = DarkScannerLayerView(frame: self.view.frame)
                    darkLayerView.delegate = self
                    view.insertSubview(darkLayerView, at: 1)
                }
            } catch {
                debugPrint("Error Device Input")
            }
        }
    }
        
        func UISetups() {
            codeFrameView.layer.borderWidth = 3.0
            codeFrameView.layer.borderColor = UIColor(red: 25.0/255.0, green: 206.0/255.0, blue: 145.0/255.0, alpha: 1.0).cgColor
        }
        
        @IBAction func startRideButtonPressed(_ sender: UIButton) {
            
            if(timerCounting){
                timerCounting = false
                timer.invalidate()
                startButton.setTitle("START", for: .normal)
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
}

extension RentABikeViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if metadataObjects.count == 0 {
            debugPrint("No Input Detected")
            return
        }
        
        let metadataObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        view.addSubview(codeFrameView)
        
//        guard let qrcodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObject) else {
//            return
//        }
        
        guard let _ = metadataObject.stringValue else {
            let alert = UIAlertController(title: "Error", message: "Not able to Scan QR Code", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            return
        }
        captureSession?.stopRunning()
        // handle the Scanned QR code
//        self.handleScannedQR(for: stringValue)
        
    }
}

extension RentABikeViewController: DarkScannerLayerViewDelegate {
    func scanningFrame() -> CGRect {
        return codeFrameView.frame
    }
}
