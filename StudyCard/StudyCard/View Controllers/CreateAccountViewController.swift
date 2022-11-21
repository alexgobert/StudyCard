//
//  CreateAccountViewController.swift
//  StudyCard
//
//  Created by Chris Tran on 11/20/22.
//

import UIKit
import FirebaseAuth

class CreateAccountViewController: UIViewController {

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordLabel: UILabel!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var agreementLabel: UILabel!
    @IBOutlet weak var createButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordField.isSecureTextEntry = true
        confirmPasswordField.isSecureTextEntry = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // theme compliance
        applyTheme()
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
                    self.performSegue(withIdentifier: "accountCreatedSegue", sender: nil)
                    self.emailField.text = nil
                    self.passwordField.text = nil
                    self.confirmPasswordField.text = nil
                }
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
        self.navigationController?.navigationBar.tintColor = ThemeManager.current.fontColor
        self.view.backgroundColor = ThemeManager.current.backgroundColor
        titleLabel.textColor = ThemeManager.current.fontColor
        emailLabel.textColor = ThemeManager.current.fontColor
        passwordLabel.textColor = ThemeManager.current.fontColor
        confirmPasswordLabel.textColor = ThemeManager.current.fontColor
        createButton.backgroundColor = ThemeManager.current.secondaryColor
        createButton.tintColor = ThemeManager.current.fontColor
        agreementLabel.textColor = ThemeManager.current.fontColor
        errorMessage.textColor = ThemeManager.current.fontColor
        
    }
}
