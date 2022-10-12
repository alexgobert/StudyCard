//
//  StudySetupVC.swift
//  StudyCard
//
//  Created by A Horvath on 10/12/22.
//

import UIKit

class StudySetupVC: UIViewController {
    
    var shuffle:Bool = true
    var itemFirst:String = ""
    var delegate: UIViewController!

    @IBOutlet weak var shuffleToggle: UISwitch!
    
    @IBOutlet weak var itemFirstCtrl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shuffle = true
        itemFirst = "Term"
        
    }
    
    @IBAction func onItemFirstChanged(_ sender: Any) {
        switch itemFirstCtrl.selectedSegmentIndex {
        case 0:
            itemFirst = "Term"
            print(itemFirst)
        case 1:
            itemFirst = "Mixed"
            print(itemFirst)
        case 2:
            itemFirst = "Definition"
            print(itemFirst)
        default:
            itemFirst = "error"
            print(itemFirst)
        }
    }
    
    @IBAction func onToggleChanged(_ sender: Any) {
        switch shuffleToggle.isOn {
        case true:
            shuffle = true
            print(shuffle)
        case false:
            shuffle = false
            print(shuffle)
        }
    }
}
