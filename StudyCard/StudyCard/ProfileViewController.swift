//
//  ProfileViewController.swift
//  StudyCard
//
//  Created by Sam Song on 10/19/22.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Outlets to main
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var profilePicImageView: UIImageView!
    
    // Image Picked boolean for Profile Picture
    var imagePicked = false
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    // Button Function for Using Camera to take Proile Picture
    
    @IBAction func takeProfilePhotoButtonPressed(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) && imagePicked == false {
            
            let imagePickerController = UIImagePickerController()
            
            imagePickerController.delegate = self
            
            imagePickerController.sourceType = .camera
            
            self.present(imagePickerController, animated: true, completion: nil)
            
            imagePicked = true
        }
    }
    
    // Function for if user presses Cancel on Camera
    func imagePickerControllerDidCancel (_ _picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        profilePicImageView.image = image
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // Button Function for using Camera roll to choose Profile Picture
    @IBAction func selectProfilePhotoButtonPressed(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            let profilePicController = UIImagePickerController()
            
            profilePicController.delegate = self
            
            profilePicController.sourceType = UIImagePickerController.SourceType.photoLibrary
            
            self.present(profilePicController, animated: true, completion: nil)
        }
        
        // Function for if user presses Cancel on Camera
        func imagePickerControllerDidCancel (_picker: UIImagePickerController) {
            self.dismiss(animated: true, completion: nil)
        }
        
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            profilePicImageView.image = image
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // Actions for Profile Altercation Buttons
    
    @IBAction func changeEmailButtonPressed(_ sender: Any) {
    }
    
    @IBAction func changePasswordButtonPressed(_ sender: Any) {
    }
    
    @IBAction func changeNameButtonPressed(_ sender: Any) {
    }
    
    @IBAction func deleteAccountButtonPressed(_ sender: Any) {
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            performSegue(withIdentifier: "signoutSegue", sender: nil)
        } catch {
            print("Sign out error")
        }
    }
}
