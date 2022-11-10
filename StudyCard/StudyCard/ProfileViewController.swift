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
        let changeEmailController = UIAlertController(
            title: "Change your email",
            message: "",
            preferredStyle: .alert)
        
        changeEmailController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter New Email Address"
            
            let saveAction = UIAlertAction(
                title: "Save",
                style: .default,
                handler: { (action : UIAlertAction!) Void in })
            
            let currentUser = Auth.auth().currentUser
            
            if Auth.auth().currentUser != nil {
                currentUser?.updateEmail(to: textField.text!) {
                    error in
                    if let error = error {
                        print(error)
                    } else {
                        print("Email changed")
                        let user = Auth.auth().currentUser
                        let name = user?.displayName!
                        let ref = Database.database().reference().child("main").child("users_sen").child(name!).child("email")
                        ref.setValue(textField.text!)
                        
                    }
                }
            }
            
        })
        
    changeEmailController.addAction(saveAction)
        }
    self.present(changeEmailController, animated: true, completion: {
        changeEmailController.view.superview?isUserInteractionEnabled = true
        changeEmailController.view.superview?.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(self.alertClose(gesture:))))

    })
    

}
    
    @IBAction func changePasswordButtonPressed(_ sender: Any) {
        
        let currentUser = Auth.auth().currentUser
        currentUser?.updatePassword(to: textField.text!) {
            error in
            if let error = error {

            } else {
                print("Success")
            }
        }
        
        let userEmail = Auth.auth().currentUser?.email
        self.password = textField.text!
        
        let credential = EmailAuthProvider.credential(withEmail: userEmail , password: textField.text!)
        
        currentUser?.reauthenticate(with: credential) {
            error in
            if let error = error {
                // error occurs
            } else {
                // user re-authenticated
            }
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
