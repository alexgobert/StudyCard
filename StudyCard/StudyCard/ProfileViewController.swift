//
//  ProfileViewController.swift
//  StudyCard
//
//  Created by Sam Song on 10/19/22.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Outlets to main
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var profilePicImageView: UIImageView!
    
    var imagePicked: Bool = false
    var observer: NSKeyValueObservation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        observer = profilePicImageView.observe(\.image, options: [.new]) {
            _, change in
            var date: String = Date().formatted()
            date.replace(" ", with: "")
            date.replace("/", with: "-")
            
            self.storeImage(name: "image\(date).jpeg", image: change.newValue!!)
        }
    }
    
    // Button Function for Using Camera to take Proile Picture
    @IBAction func takeProfilePhotoButtonPressed(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) && !imagePicked {
            
            let imagePickerController = UIImagePickerController()
            
            imagePickerController.delegate = self
            imagePickerController.sourceType = .camera
            
            self.present(imagePickerController, animated: true)
            
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
    }
    
    func storeImage(name: String, image: UIImage) {
        let pfpRef = Storage.storage().reference(forURL: "profile_pictures/\(name)")
        
        guard let imageData = image.jpegData(compressionQuality: 1) else {
            return
        }
        
        pfpRef.putData(imageData) {
            _, error in
            if let error = error {
                print(error.localizedDescription)
            }
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
