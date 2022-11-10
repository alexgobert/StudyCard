//
//  SettingsViewController.swift
//  StudyCard
//
//  Created by Chris Tran on 11/7/22.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var fontMenuDropDown: UIView!
    
    let fontsArray = ["Font 1", "Font 2", "Font 3", "Font 4"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func showFontMenu(_ sender: Any) {
        let fontController = UIAlertController(
            title: "Font",
            message: "Please select a font",
            preferredStyle: .alert)
        fontController.addAction(UIAlertAction(
            title: "Comic Sans",
            style: .default))
        fontController.addAction(UIAlertAction(
            title: "Helvetica",
            style: .default))
        fontController.addAction(UIAlertAction(
            title: "Times New Roman",
            style: .default))
        fontController.addAction(UIAlertAction(
            title: "Open Sans",
            style: .default))
        fontController.addAction(UIAlertAction(
            title: "SF Pro",
            style: .default))
        fontController.addAction(UIAlertAction(
            title: "Cancel",
            style: .cancel))
        present(fontController, animated: true)
    }
}
