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
        catchNotification()
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
        // changes color
        self.view.backgroundColor = globalBkgdColor
        titleLabel.textColor = globalFontColor
        emailLabel.textColor = globalFontColor
        passwordLabel.textColor = globalFontColor
        confirmPasswordLabel.textColor = globalFontColor
        createButton.backgroundColor = globalSecondaryColor
        createButton.tintColor = globalFontColor
        agreementLabel.textColor = globalFontColor
        errorMessage.textColor = globalFontColor
        emailField.tintColor = globalSecondaryColor
        passwordField.tintColor = globalSecondaryColor
        confirmPasswordField.tintColor = globalSecondaryColor
        emailField.textColor = globalFontColor
        emailField.font = globalTextFont
        passwordField.textColor = globalFontColor
        passwordField.font = globalTextFont
        confirmPasswordField.textColor = globalFontColor
        confirmPasswordField.font = globalTextFont
        
        // changes font
        titleLabel.font = globalTitleFont
        emailLabel.font = globalButtonFont
        emailField.font = globalTextFont
        emailField.backgroundColor = globalSecondaryColor.withAlphaComponent(0.50)
        self.emailField.attributedPlaceholder = NSAttributedString(
            string: "Enter your email",
            attributes: [NSAttributedString.Key.foregroundColor: globalFontColor.withAlphaComponent(0.50)])
        passwordLabel.font = globalButtonFont
        passwordField.font = globalTextFont
        passwordField.backgroundColor = globalSecondaryColor.withAlphaComponent(0.50)
        self.passwordField.attributedPlaceholder = NSAttributedString(
            string: "Create a password",
            attributes: [NSAttributedString.Key.foregroundColor: globalFontColor.withAlphaComponent(0.50)])
        confirmPasswordLabel.font = globalButtonFont
        confirmPasswordField.font = globalTextFont
        confirmPasswordField.backgroundColor = globalSecondaryColor.withAlphaComponent(0.50)
        self.confirmPasswordField.attributedPlaceholder = NSAttributedString(
            string: "Re-enter password",
            attributes: [NSAttributedString.Key.foregroundColor: globalFontColor.withAlphaComponent(0.50)])
        createButton.titleLabel?.font = globalButtonFont
        agreementLabel.font = globalTextFont
        errorMessage.font = globalButtonFont
        
        
        // alters the navigation bar back button
        self.navigationController?.navigationBar.tintColor = globalFontColor
        let appearance = UINavigationBarAppearance()
        let button = UIBarButtonItemAppearance(style: .plain)
            button.normal.titleTextAttributes = [NSAttributedString.Key.font: globalBackButtonFont, NSAttributedString.Key.foregroundColor: globalFontColor]
        appearance.backgroundColor = globalBkgdColor
        appearance.buttonAppearance = button
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
}
