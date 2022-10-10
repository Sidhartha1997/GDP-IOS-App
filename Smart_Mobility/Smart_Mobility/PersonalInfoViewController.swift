//
//  PersonalInfoViewController.swift
//  Smart_Mobility
//
//  Created by Eppalapelli,Satheesh on 9/21/22.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage

class PersonalInfoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var profileImageOutlet: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var signOutButtonPressed: UIButton!
    
    @IBOutlet weak var changePictureButtonPressed: UIButton!
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailIdTextField: UITextField!
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    @IBOutlet weak var updatePasswordTextField: UITextField!
    
    @IBOutlet weak var cancelButtonPressed: UIButton!
    
    @IBOutlet weak var savePersonalInfoButtonPressed: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        Auth.auth().addStateDidChangeListener({(auth, user) in
            
            if user == nil {
                let signinview = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC")
                self.present(signinview!, animated: true, completion: nil)
                
            }
        })
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    @IBAction func signOutButtonPressed(_ sender: UIButton) {
        
        let user = Auth.auth().currentUser
        
        if user != nil {
            do {
                try Auth.auth().signOut()
                // Switch To Login Page
                // Transition to the home screen
                self.transitionToHome()
            } catch let error as NSError {
                let alert = UIAlertController(title: "Alert", message: (error as! String), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func transitionToHome() {
        
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    
    
    // MARK: Profile Picture
    
    @IBAction func changePictureButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Change Profile Picture", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Remove Profile Picture", style: .destructive, handler: {(action) in
            self.profileImageOutlet.image = nil
            guard let user = Auth.auth().currentUser else { return }
            let storageRef = Storage.storage().reference()
            storageRef.child("shared/\(user.uid)/profile-400x400.png").delete {(error) in
                print("Error occurred deleting profile image from Firebase Storage: \(error?.localizedDescription)")
            }
            storageRef.child("shared/\(user.uid)/profile-80x80.png").delete {(error) in
                print("Error occurred deleting profile thumbnail image from Firebase Storage: \(error?.localizedDescription)")
            }
        }))
        alert.addAction(UIAlertAction(title: "Choose from Library", style: .default, handler: {(action) in
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.modalPresentationStyle = .popover // for iPad
            picker.popoverPresentationController?.sourceView = sender
            picker.popoverPresentationController?.sourceRect = sender.bounds
            picker.delegate = self
            self.present(picker, animated: true, completion: {() -> Void in })
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {(action) in
        }))
        self.present(alert, animated: true, completion: {() -> Void in })
    }
    
    
    // After the user cancels the picer, revert and do nothing
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // After the user picks an image, update the view and Firebase Storage
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        
        guard let pickedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage,
              let user = Auth.auth().currentUser else {
            picker.dismiss(animated: true, completion: nil)
            return
        }
        
        guard let image = pickedImage.scaleAndCrop(withAspect: true, to: 200),
              let imageData = image.pngData() else {
            picker.dismiss(animated: true, completion: nil)
            return
        }
        // TODO: Handle @1x, @3x sizes and on the Storyboard, turn off Content Mode = Aspect Fill (and Clip to Bounds = true)
        
        // Display the picked image
        self.profileImageOutlet.image = image
        
        // Upload the new profile image to Firebase Storage
        let storageRef = Storage.storage().reference().child("shared/\(user.uid)/profile-400x400.png")
        let metadata = StorageMetadata(dictionary: ["contentType": "image/png"])
        let uploadTask = storageRef.putData(imageData, metadata: metadata) { (metadata, error) in
            guard metadata != nil else {
                print("Error uploading image to Firebase Storage: \(error?.localizedDescription)")
                return
            }
            // Metadata dictionary: bucket, contentType, downloadTokens, downloadURL, [file]name, updated, et al
            
            // Log the event with Firebase Analytics
            //            Analytics.logEvent("User_NewProfileImage", parameters: nil)
            
            // Create a thumbnail image for future use, too
            // TODO: Move this to a server-side background worker task
            guard let image = pickedImage.scaleAndCrop(withAspect: true, to: 40),
                  let imageData = image.pngData() else {
                return
            }
            let storageRef = Storage.storage().reference().child("shared/\(user.uid)/profile-80x80.png")
            storageRef.putData(imageData, metadata: StorageMetadata(dictionary: ["contentType": "image/png"]))
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // If a user is logged in, setup the view with name, profile image, et al
        if let user = Auth.auth().currentUser {
            
            nameLabel.text = user.displayName ?? user.email
            
            if profileImageOutlet.image == nil {
                // Download the profile image from Firebase Storage with a maximum allowed size of 2MB (2 * 1024 * 1024 bytes)
                activityIndicator.startAnimating()
                let imageStorageRef = Storage.storage().reference().child("shared/\(user.uid)/profile-400x400.png")
                let downloadTask = imageStorageRef.getData(maxSize: 2 * 1024 * 1024) { data, error in
                    // Error available with .localizedDescription, but can simply be that the image does not exist yet
                    self.activityIndicator.stopAnimating()
                    if error == nil, let data = data {
                        self.profileImageOutlet.image = UIImage(data: data)
                    }
                }
            }
        }
        
        Database
            .database()
            .reference()
            .child("Users")
            .child(Auth.auth().currentUser!.uid)
            .child("Advertisements")
            .queryOrderedByKey()
            .observeSingleEvent(of: .value, with: { snapshot in

                guard let dict = snapshot.value as? [String:Any] else {
                    print("Error")
                    return
                }
                let imageAd = dict["imageAd"] as? String
                let priceAd = dict["priceAd"] as? String
            })
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func updatePersonalInfoButtonPressed(_ sender: UIButton) {
        
        let firstname = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let lastname = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = emailIdTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let phonenumber = phoneNumberTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = updatePasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let user = Auth.auth().currentUser
        
        if user != nil {
            var ref: DatabaseReference!
            ref = Database.database().reference(withPath: "smartmobility").child("users").child((user?.uid)!)
            do {
                if (firstname != nil) {
                    ref.setValue(["firstname": firstNameTextField.text!])
                }
                else if (lastname != nil) {
                    ref.setValue(["lastname": lastNameTextField.text!])
                }
                else if (email == user?.uid) {
                    ref.setValue(["email": emailIdTextField.text!])
                }
                else if (phonenumber != nil) {
                    ref.setValue(["phonenumber": phoneNumberTextField.text!])
                }
                else if (password != nil) {
                    ref.setValue(["password": updatePasswordTextField.text!])
                }
                else {
                    let alert = UIAlertController(title: "Alert", message: "Nothing to Change!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                
                let alert = UIAlertController(title: "Alert", message: "Updated Successfully!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
//                // Switch To Login Page
//                // Transition to the home screen
//                self.transitionToHome()
            }
            catch let error as NSError {
                let alert = UIAlertController(title: "Alert", message: (error as! String), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }
    
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}
