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
    }
}
