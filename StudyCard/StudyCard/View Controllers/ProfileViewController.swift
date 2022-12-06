//
//  ProfileVC.swift
//  StudyCard
//
//  Created by Sam Song on 10/19/22.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import CryptoKit
import AVFoundation

class ProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Outlets to main
    @IBOutlet weak var profilePicImageView: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var passwordButton: UIButton!
    @IBOutlet weak var deleteAcctButton: UIButton!
    @IBOutlet weak var takePicButton: UIButton!
    @IBOutlet weak var selectPicButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    let imagePicker = UIImagePickerController()
    let storageRef: StorageReference = Storage.storage().reference().child("profile_pictures")
    let maxImageSize: Int64 = 10 * 1024 * 1024 // MB
    var imageName: String = "" {
        willSet {
            if imageName != "" && imageName != newValue, let image = profilePicImageView.image {
                deleteImage(name: self.imageName)
                storeImage(name: newValue, image: image)
            }
        }
    }
    var observer: NSKeyValueObservation!
    var uploadTasks: Queue<StorageUploadTask>! {
        didSet {
            if uploadTasks.peek() == nil, let photoURL = Auth.auth().currentUser?.photoURL {
                self.loadImage(photoURL: photoURL)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // adds border to image view
        profilePicImageView.layer.borderWidth = 1
        
        uploadTasks = Queue()
        imagePicker.delegate = self
        
        catchNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let user = Auth.auth().currentUser
        self.emailLabel.text = user?.email ?? ""
 
        // load user image
        if let photoURL = user?.photoURL {
            imageName = photoURL.lastPathComponent
            
            // if there's no upload task, download
            if uploadTasks.peek() == nil {
                loadImage(photoURL: photoURL)
            }
        }
        
        // theme compliance
        applyTheme()
    }
    
    // Button Function for Using Camera to take Profile Picture
    @IBAction func takeProfilePhotoButtonPressed(_ sender: Any) {
        guard UIImagePickerController.availableCaptureModes(for: .rear) != nil else {
            // no rear camera is available
            errorAlert(message: "Sorry, this device has no rear camera")
            return
        }
            
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined: // undetermined access to video
            AVCaptureDevice.requestAccess(for: .video) {
                accessGranted in
                guard accessGranted else { // return if denied, fall through if accepted
                    return
                }
            }
        case .authorized: // access granted, fall through
            break
        default: // access not granted, return
            errorAlert(message: "access denied")
            return
        }
        
        imagePicker.sourceType = .camera
        imagePicker.cameraCaptureMode = .photo
        present(imagePicker, animated: true)
    }
    
    // Function for if user presses Cancel on Camera
    func imagePickerControllerDidCancel (_ _picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as! UIImage
        
        // https://www.hackingwithswift.com/example-code/cryptokit/how-to-calculate-the-sha-hash-of-a-string-or-data-instance
        let imageData: Data = (image.jpegData(compressionQuality: 0.5))!
        let hashedData: SHA256Digest = SHA256.hash(data: imageData)
        let hashedString: String = hashedData.compactMap { String(format: "%02x", $0) }.joined()
        
        profilePicImageView.image = image
        imageName = hashedString + ".jpg"
        
        deleteImage(name: imageName)
        storeImage(name: imageName, image: image)
        
        dismiss(animated: true)
    }
    
    
    // Button Function for using Camera roll to choose Profile Picture
    @IBAction func selectProfilePhotoButtonPressed(_ sender: Any) {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            return
        }

        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true)
    }
    
    // Stores profile picture in Firebase
    func storeImage(name: String, image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.5), let user = Auth.auth().currentUser else {
            return
        }
        
        let pfpRef = storageRef.child(name)
        
        // store image
        let uploadTask = pfpRef.putData(imageData) { _, error in
            if let error = error {
                self.errorAlert(message: error.localizedDescription)
            }
        }
        
        uploadTasks.enqueue(uploadTask)
        
        // wait for image URL to be generated server-side before attempting to store it in user data
        uploadTask.observe(.success) { _ in
            self.updateProfileWithImageURL(ref: pfpRef, user: user)
            self.uploadTasks.dequeue()
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
                self.errorAlert(message: error.localizedDescription)
            }
            
            // must commit changes within downloadURL callstack to avoid async errors
            // https://stackoverflow.com/questions/51821553/invalid-call-to-setphotourl-after-commitchangeswithcallback
            changeRequest.commitChanges { error in // save new profile data
                if let error = error {
                    self.errorAlert(message: error.localizedDescription)
                }
            }
        }
    }
    
    // Deletes profile picture from Firebase
    func deleteImage(name: String) {
        guard !name.isEmpty else {
            return
        }
        
        let ref = storageRef.child(name)
        ref.delete { _ in }
    }
    
    func loadImage(photoURL: URL) {
        let photoRef = Storage.storage().reference(forURL: photoURL.absoluteString)
        
        // download to memory with max size 10 MB
        photoRef.getData(maxSize: maxImageSize) { data, error in
            // update profilePicImageView with retrieved image
            if let data = data {
                self.profilePicImageView.image = UIImage(data: data)
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
            self.navigationController?.popViewController(animated: true)
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
                  let currentPassword = changePasswordController.textFields?.first?.text,
                  let newPassword = changePasswordController.textFields?.last?.text,
                  !currentPassword.isEmpty,
                  !newPassword.isEmpty else {
                return
            }
            
            // reauthenticate and change password
            let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)
            currentUser.reauthenticate(with: credential) { _, error in
                if let error = error {
                    self.errorAlert(message: error.localizedDescription)
                } else {
                    self.updatePassword(user: currentUser, newPassword: newPassword)
                }
                
                self.navigationController?.popViewController(animated: true)
                
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        changePasswordController.addAction(saveAction)
        changePasswordController.addAction(cancelAction)
        
        present(changePasswordController, animated: true)
    }
        
    @IBAction func deleteAccountButtonPressed(_ sender: Any) {
        
        // reauthenticate user before deleting acount
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        let deleteAccountController = UIAlertController(
            title: "Delete your account",
            message: nil,
            preferredStyle: .alert
        )
        
        let deleteAction = UIAlertAction(title: "Delete", style: .default) { _ in
            guard let email = currentUser.email,
                  let currentEmail = deleteAccountController.textFields?.first?.text,
                  let currentPassword = deleteAccountController.textFields?.last?.text,
                  !currentEmail.isEmpty,
                  !currentPassword.isEmpty else {
                return
            }
            
            let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)
            currentUser.reauthenticate(with: credential) { _, error in
                if let error = error {
                    self.errorAlert(message: error.localizedDescription)
                } else {
                    currentUser.delete();
                    self.dismiss(animated: true) // dismiss entire stack
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        deleteAccountController.addAction(cancelAction)
        deleteAccountController.addAction(deleteAction)
        deleteAccountController.addTextField { textField in
            textField.placeholder = "Enter Email"
        }
        deleteAccountController.addTextField { textField in
            textField.placeholder = "Enter Password"
        }
        
        present(deleteAccountController, animated: true)
    }

    @IBAction func logoutButtonPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            dismiss(animated: true) // dismiss entire stack
        } catch {
            errorAlert(message: "Sign out error")
        }
    }
    
    // updates the email of a user
    // @param user is a Firebase User object who's email will be changed
    // @param newEmail is a string containing the desired new email
    func updateEmail(user: User, newEmail: String) {
        user.updateEmail(to: newEmail) { error in
            if let error = error {
                self.errorAlert(message: error.localizedDescription)
            }
        }
    }
    
    // updates the password of a user
    // @param user is a Firebase User object who's password will be changed
    // @param newPassword is a string containing the desired new password
    func updatePassword(user: User, newPassword: String) {
        user.updatePassword(to: newPassword) { error in
            if let error = error {
                self.errorAlert(message: error.localizedDescription)
            }
        }
    }
    
    func catchNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTheme), name: NSNotification.Name("ThemeUpdate"), object: nil)
    }
    
    @objc func reloadTheme() {
        applyTheme()
    }
    
    func applyTheme() {
        profilePicImageView.layer.borderColor = globalFontColor.cgColor
        self.view.backgroundColor = globalBkgdColor
        emailLabel.textColor = globalFontColor
        
        emailLabel.font = globalTextFont
        
        // alters the navigation bar title appearance
        let appearance = UINavigationBarAppearance()
        
        let button = UIBarButtonItemAppearance(style: .plain)
        button.normal.titleTextAttributes = [
            .font: globalBackButtonFont,
            .foregroundColor: globalFontColor
        ]
        
        appearance.backgroundColor = globalBkgdColor
        appearance.buttonAppearance = button

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        let buttons: [UIButton] = [
            emailButton,
            passwordButton,
            deleteAcctButton,
            takePicButton,
            selectPicButton,
            logoutButton
        ]
        for button in buttons {
            button.titleLabel?.font = globalButtonFont
            button.tintColor = globalFontColor
        }
        
    }
}
