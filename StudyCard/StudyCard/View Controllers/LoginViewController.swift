//
//  LoginViewController.swift
//  StudyCard
//
//  Created by Chris Tran on 10/20/22.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var resetPasswordButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorMessage: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        passwordField.isSecureTextEntry = true
        
        Auth.auth().addStateDidChangeListener() {
            auth, user in
            if user != nil {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
                self.emailField.text = nil
                self.passwordField.text = nil
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // theme compliance
        applyTheme()
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!) {
            (authResult, error) in
            if let error = error as NSError? {
                self.errorMessage.text = error.localizedDescription
            } else {
                self.errorMessage.text = ""
            }
        }
    }

    @IBAction func resetPasswordButtonPressed(_ sender: Any) {
        let alert = UIAlertController(
            title: "Reset Password",
            message: "Please enter your email and Firebase will send you a password reset email.",
            preferredStyle: .alert
        )
        
        alert.addTextField {
            tfEmail in
            tfEmail.placeholder = "Email"
        }
        
        let resetAction = UIAlertAction(title: "Reset", style: .default) {
            _ in
            let emailField: UITextField = alert.textFields![0]
            
            // prompts Firebase to send a password reset email
            Auth.auth().sendPasswordReset(withEmail: emailField.text!) {
                error in
                if let error = error {
                    self.errorMessage.text = error.localizedDescription
                } else {
                    self.errorMessage.text = ""
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(resetAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    func catchNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTheme), name: NSNotification.Name("ThemeUpdate"), object: nil)
    }
    
    @objc func reloadTheme() {
        applyTheme()
    }
    
    func applyTheme() {
        // changes color
        self.view.backgroundColor = ThemeManager.current.backgroundColor
        titleLabel.textColor = ThemeManager.current.fontColor
        loginButton.backgroundColor = ThemeManager.current.secondaryColor
        errorMessage.textColor = ThemeManager.current.fontColor
        emailField.backgroundColor = ThemeManager.current.secondaryColor.withAlphaComponent(0.50)
        emailField.textColor = ThemeManager.current.fontColor
        self.emailField.attributedPlaceholder = NSAttributedString(
            string: "Email",
            attributes: [NSAttributedString.Key.foregroundColor: ThemeManager.current.fontColor.withAlphaComponent(0.50)])
        passwordField.backgroundColor = ThemeManager.current.secondaryColor.withAlphaComponent(0.50)
        passwordField.textColor = ThemeManager.current.fontColor
        self.passwordField.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor: ThemeManager.current.fontColor.withAlphaComponent(0.50)])
        
        // changes font
        titleLabel.font = globalTitleFont
        emailField.font = globalTextFont
        passwordField.font = globalTextFont
        errorMessage.font = globalButtonFont
        
        let buttons: [UIButton] = [
            resetPasswordButton,
            loginButton,
            signUpButton
        ]
        for button in buttons {
            button.titleLabel?.font = globalButtonFont
            button.tintColor = ThemeManager.current.fontColor
        }
    }
}
