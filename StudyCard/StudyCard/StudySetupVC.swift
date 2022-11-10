//
//  StudySetupVC.swift
//  StudyCard
//
//  Created by A Horvath on 10/12/22.
//

import UIKit

class StudySetupVC: UIViewController {
    
    var cards: CardSet!
    var shuffle: Bool = true
    var itemFirst: String = ""

    @IBOutlet weak var shuffleToggle: UISwitch!
    @IBOutlet weak var itemFirstCtrl: UISegmentedControl!
    @IBOutlet weak var shuffleLabel: UILabel!
    @IBOutlet weak var itemFirstLabel: UILabel!
    @IBOutlet weak var confirmButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // theme compliance
        view.backgroundColor = globalBkgdColor
        
        // theme compliance
        shuffleLabel.font = globalFont
        shuffleLabel.textColor = globalFontColor
        itemFirstLabel.font = globalFont
        itemFirstLabel.textColor = globalFontColor
        itemFirstCtrl.selectedSegmentTintColor = globalBkgdColor
        itemFirstCtrl.backgroundColor = globalBkgdColor
        itemFirstCtrl.setTitleTextAttributes([.font: globalFont!, .foregroundColor: globalFontColor!], for: .normal)
        confirmButton.tintColor = globalFontColor
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "StudySegue", let dest = segue.destination as? StudyViewController {
            cards.shuffle(shuffle)
            
            dest.setCards(cards)
            dest.itemFirst = itemFirst
        }
    }
    
    @IBAction func onItemFirstChanged(_ sender: Any) {
        itemFirst = itemFirstCtrl.titleForSegment(at: itemFirstCtrl.selectedSegmentIndex)!
    }
    
    @IBAction func onToggleChanged(_ sender: Any) {
        shuffle = shuffleToggle.isOn
    }
}
