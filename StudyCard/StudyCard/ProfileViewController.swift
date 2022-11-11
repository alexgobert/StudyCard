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
    
    let storageRef: StorageReference = Storage.storage().reference().child("profile_pictures")
    let maxImageSize: Int64 = 10 * 1024 * 1024 // MB
    var imageName: String = ""
    var observer: NSKeyValueObservation!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // load user image
        if let user = Auth.auth().currentUser, let photoURL = user.photoURL {
            loadImage(photoURL: photoURL)
            imageName = photoURL.lastPathComponent
            self.emailLabel.text = user.email ?? ""
            self.nameLabel.text = user.displayName ?? ""
        }
        
        // set up profile picture observer
        observer = profilePicImageView.observe(\.image, options: [.new]) {
            _, change in
            // name images by date
            var date: String = Date().formatted()
            date.replace(" ", with: "")
            date.replace("/", with: "-")
            date.replace(",", with: "")
            
            self.deleteImage(name: self.imageName)
            self.imageName = "image\(date).jpeg"
            self.storeImage(name: self.imageName, image: change.newValue!!)
        }
        
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
        let uploadTask: StorageUploadTask = pfpRef.putData(imageData) { _, error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        
        // wait for image URL to be generated server-side before attempting to store it in user data
        uploadTask.observe(.success) { _ in
            self.updateProfileWithImageURL(ref: pfpRef, user: user)
        }
    }
    
    // stores url at StorageReference in user's photo URL
    // @param ref is a Firebase StorageReference, assumed to point at user's profile picture
    // @param user is a Firebase user object
    func updateProfileWithImageURL(ref: StorageReference, user: User) {
        // https://firebase.google.com/docs/auth/ios/manage-users#update_a_users_profile
        let changeRequest = user.createProfileChangeRequest()
        ref.downloadURL { url, error in
            if let url = url {
                changeRequest.photoURL = url
            } else if let error = error {
                print(error.localizedDescription)
            }
            
            // must commit changes within downloadURL callstack to avoid async errors
            // https://stackoverflow.com/questions/51821553/invalid-call-to-setphotourl-after-commitchangeswithcallback
            changeRequest.commitChanges { error in // save new profile data
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    // Deletes profile picture from Firebase
    func deleteImage(name: String) {
        guard name != "" else {
            return
        }
        
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
        guard let currentUser = Auth.auth().currentUser else { return }

        let changeEmailController = UIAlertController(
            title: "Change your email",
            message: nil,
            preferredStyle: .alert
        )
        
        changeEmailController.addTextField { textField in
            textField.placeholder = "Enter New Email Address"
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let textField = changeEmailController.textFields?.first,
                  let newEmail = textField.text,
                  !newEmail.isEmpty else {
                return
                
            }
            self.updateEmail(user: currentUser, newEmail: newEmail)
        }
        
        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: .cancel
        )
        
        changeEmailController.addAction(saveAction)
        changeEmailController.addAction(cancelAction)
        
        present(changeEmailController, animated: true)
    }

    @IBAction func changePasswordButtonPressed(_ sender: Any) {
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        
        let changePasswordController = UIAlertController(
            title: "Change your password",
            message: nil,
            preferredStyle: .alert
        )
        
        changePasswordController.addTextField { textField in
            textField.placeholder = "Enter Current Password"
        }
        
        changePasswordController.addTextField { textField in
            textField.placeholder = "Enter New Password"
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let email = currentUser.email,
                  let currentPasswordTextField = changePasswordController.textFields?.first,
                  let newPasswordTextField = changePasswordController.textFields?.last,
                  let currentPassword = currentPasswordTextField.text,
                  let newPassword = newPasswordTextField.text,
                  !currentPassword.isEmpty,
                  !newPassword.isEmpty else {
                return
            }
            
            // reauthenticate and change password
            let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)
            currentUser.reauthenticate(with: credential) { result, error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    self.updatePassword(user: currentUser, newPassword: newPassword)
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        changePasswordController.addAction(saveAction)
        changePasswordController.addAction(cancelAction)
        
        present(changePasswordController, animated: true)
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
    
    // updates the email of a user
    // @param user is a Firebase User object who's email will be changed
    // @param newEmail is a string containing the desired new email
    func updateEmail(user: User, newEmail: String) {
        user.updateEmail(to: newEmail) { error in
            if let error = error {
                print(error)
            } else {
                print("Success")
            }
        }
    }
    
    // updates the password of a user
    // @param user is a Firebase User object who's password will be changed
    // @param newPassword is a string containing the desired new password
    func updatePassword(user: User, newPassword: String) {
        user.updatePassword(to: newPassword) {
            error in
            if let error = error {
                print(error.localizedDescription)
                return
            } else {
                print("Success")
            }
        }
    }
}
