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
    var itemFirst: String! // Term, Mixed, Definition
    var delegate: DeleteList!

    @IBOutlet weak var shuffleToggle: UISwitch!
    @IBOutlet weak var itemFirstCtrl: UISegmentedControl!
    @IBOutlet weak var shuffleLabel: UILabel!
    @IBOutlet weak var itemFirstLabel: UILabel!
    @IBOutlet weak var confirmButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        itemFirst = itemFirstCtrl.titleForSegment(at: itemFirstCtrl.selectedSegmentIndex)!
        
        // theme compliance
        view.backgroundColor = globalBkgdColor
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
            
            dest.setCards(&cards)
            dest.itemFirst = itemFirst
        }
    }
    
    @IBAction func onItemFirstChanged(_ sender: Any) {
        itemFirst = itemFirstCtrl.titleForSegment(at: itemFirstCtrl.selectedSegmentIndex)!
        
        print(itemFirst)
    }
    
    @IBAction func onToggleChanged(_ sender: Any) {
        shuffle = shuffleToggle.isOn
        
        print(shuffle)
        
    }
    
    @IBAction func editPressed(_ sender: Any) {
        print("edit")
    }
    
    @IBAction func deletePressed(_ sender: Any) {
        print("delete")
        let otherVC = delegate!
        otherVC.deleteItem(cardSet: cards)
    }
    
}
