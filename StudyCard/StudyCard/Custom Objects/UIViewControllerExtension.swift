//
//  UIViewControllerExtension.swift
//  StudyCard
//
//  Created by Alex Gobert on 11/11/22.
//

import UIKit

// extension to UIViewController to add custom functions without subclassing
extension UIViewController {
    
    // displays a message-less alert with an error message
    func errorAlert(message: String) {
        guard !message.isEmpty else {
            return
        }
        
        let alert = UIAlertController(
            title: message,
            message: nil,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        
        present(alert, animated: true)
    }
}
