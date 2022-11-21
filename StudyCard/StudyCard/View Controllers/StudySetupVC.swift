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
        applyTheme()
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
    
    @IBAction func editPressed(_ sender: Any) {
        print("edit")
    }
    
    @IBAction func deletePressed(_ sender: Any) {
        delegate.deleteItem(cardSet: cards)
        navigationController?.popViewController(animated: true)
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
        shuffleLabel.font = globalFont
        shuffleLabel.textColor = ThemeManager.current.fontColor
        itemFirstLabel.font = globalFont
        itemFirstLabel.textColor = ThemeManager.current.fontColor
        itemFirstCtrl.selectedSegmentTintColor = ThemeManager.current.secondaryColor
        itemFirstCtrl.backgroundColor = ThemeManager.current.secondaryColor
        itemFirstCtrl.setTitleTextAttributes([.font: globalFont!, .foregroundColor: ThemeManager.current.fontColor], for: .normal)
        confirmButton.tintColor = ThemeManager.current.secondaryColor
        editButton.tintColor = ThemeManager.current.secondaryColor
        deleteButton.tintColor = ThemeManager.current.secondaryColor
        
    }
    
}
