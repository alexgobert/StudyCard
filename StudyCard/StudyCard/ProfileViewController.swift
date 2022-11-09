//
//  ProfileVC.swift
//  StudyCard
//
//  Created by Sam Song on 10/19/22.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

class ProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Outlets to main
    @IBOutlet weak var profilePicImageView: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var passwordButton: UIButton!
    @IBOutlet weak var nameButton: UIButton!
    @IBOutlet weak var deleteAcctButton: UIButton!
    @IBOutlet weak var takePicButton: UIButton!
    @IBOutlet weak var selectPicButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    let storageRef: StorageReference = Storage.storage().reference(forURL: "profile_pictures")
    let maxImageSize: Int64 = 10 * 1024 * 1024 // MB
    var imageName: String = ""
    var observer: NSKeyValueObservation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load user image
        if let user = Auth.auth().currentUser, let photoURL = user.photoURL {
            loadImage(photoURL: photoURL)
            imageName = photoURL.lastPathComponent
        }
        
        // set up profile picture observer
        observer = profilePicImageView.observe(\.image, options: [.new]) {
            _, change in
            // name images by date
            var date: String = Date().formatted()
            date.replace(" ", with: "")
            date.replace("/", with: "-")
            
            self.deleteImage(name: self.imageName)
            self.imageName = "image\(date).jpeg"
            self.storeImage(name: self.imageName, image: change.newValue!!)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // theme compliance
        view.backgroundColor = globalBkgdColor
        
        // theme compliance
        emailLabel.font = globalFont
        nameLabel.font = globalFont
        let buttons: [UIButton] = [
            emailButton,
            passwordButton,
            nameButton,
            deleteAcctButton,
            takePicButton,
            selectPicButton,
            logoutButton
        ]
        for button in buttons {
            button.titleLabel?.font = globalFont
        }
    }
    
    // Button Function for Using Camera to take Profile Picture
    @IBAction func takeProfilePhotoButtonPressed(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            let imagePickerController = UIImagePickerController()
            
            imagePickerController.delegate = self
            imagePickerController.sourceType = .camera
            
            self.present(imagePickerController, animated: true)
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
    
    // Stores profile picture in Firebase
    func storeImage(name: String, image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 1), let user = Auth.auth().currentUser else {
            return
        }
        
        let pfpRef = storageRef.child("\(user.uid)/\(name)")
        
        // store image
        pfpRef.putData(imageData) { _, error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        
        // store image url in profile data
        // https://firebase.google.com/docs/auth/ios/manage-users#update_a_users_profile
        let changeRequest = user.createProfileChangeRequest()
        pfpRef.downloadURL { url, error in
            if let url = url {
                changeRequest.photoURL = url
                
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        changeRequest.commitChanges { error in // save new profile data
            if let error = error {
                print(error.localizedDescription)
            }
        }
        
    }
    
    // Deletes profile picture from Firebase
    func deleteImage(name: String) {
        let ref = storageRef.child(name)
        ref.delete { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func loadImage(photoURL: URL) {
        let photoRef = Storage.storage().reference(forURL: photoURL.absoluteString)
        
        // download to memory with max size 10 MB
        photoRef.getData(maxSize: maxImageSize) { data, error in
            // update profilePicImageView with retrieved image
            if let data = data {
                self.profilePicImageView.image = UIImage(data: data)
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    // Actions for Profile Alteration Buttons
    @IBAction func changeEmailButtonPressed(_ sender: Any) {
        let emailChangeAlert = UIAlertController(title: "Change your email",
                                      message: "",
                                      preferredStyle: .alert)
        emailChangeAlert.addTextField {
        }
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
