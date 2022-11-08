//
//  SettingsViewController.swift
//  StudyCard
//
//  Created by Chris Tran on 11/7/22.
//

import UIKit
import DropDown

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var fontMenuDropDown: UIView!
    
    let fontMenu = DropDown()
    let fontsArray = ["Font 1", "Font 2", "Font 3", "Font 4"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fontMenu.anchorView = fontMenuDropDown
        fontMenu.dataSource = fontsArray
    }
    
    @IBAction func showFontMenu(_ sender: Any) {
        fontMenu.show()
    }
}
