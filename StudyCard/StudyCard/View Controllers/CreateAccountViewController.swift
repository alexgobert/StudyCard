//
//  CreateAccountViewController.swift
//  StudyCard
//
//  Created by Chris Tran on 11/20/22.
//

import UIKit
import FirebaseAuth

class CreateAccountViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var errorMessage: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        passwordField.isSecureTextEntry = true
        confirmPasswordField.isSecureTextEntry = true
    }
    
    @IBAction func onCreateButtonPressed(_ sender: Any) {
        // if passwords do not match, print error message
        if (passwordField.text! != confirmPasswordField.text) {
            self.errorMessage.text = "Passwords do not match!"
        } else {
            // if passwords do match, try to create a user
            Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) {
                authResult, error in
                if let error = error as NSError? {
                    self.errorMessage.text = "\(error.localizedDescription)"
                } else {
                    self.errorMessage.text = "Created an account successfully!"
                    self.errorMessage.textColor = .green
                    self.performSegue(withIdentifier: "accountCreatedSegue", sender: nil)
                    self.emailField.text = nil
                    self.passwordField.text = nil
                    self.confirmPasswordField.text = nil
                }
            }
        }
    }
}
