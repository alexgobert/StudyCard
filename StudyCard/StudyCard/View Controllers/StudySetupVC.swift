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
    var delegate: ViewController!
    var setIndex: Int!

    @IBOutlet weak var shuffleToggle: UISwitch!
    @IBOutlet weak var itemFirstCtrl: UISegmentedControl!
    @IBOutlet weak var shuffleLabel: UILabel!
    @IBOutlet weak var itemFirstLabel: UILabel!
    @IBOutlet weak var confirmButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        catchNotification()
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
        
        if segue.identifier == "SetEditSegue", let dest = segue.destination as? SetCreationVC {
            dest.importedSet = cards
            dest.delegate = delegate
            dest.setIndex = setIndex
        }
    }
    
    @IBAction func onItemFirstChanged(_ sender: Any) {
        itemFirst = itemFirstCtrl.titleForSegment(at: itemFirstCtrl.selectedSegmentIndex)!
    }
    
    @IBAction func onToggleChanged(_ sender: Any) {
        shuffle = shuffleToggle.isOn
        if shuffleToggle.isOn {
            shuffleToggle.backgroundColor = ThemeManager.current.lightColor
            shuffleToggle.onTintColor = ThemeManager.current.lightColor
        } else {
            shuffleToggle.backgroundColor = ThemeManager.current.fontColor.withAlphaComponent(0.8)
            shuffleToggle.tintColor = ThemeManager.current.fontColor.withAlphaComponent(0.8)
        }
        
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
        // changes color
        self.view.backgroundColor = ThemeManager.current.backgroundColor
        shuffleLabel.textColor = ThemeManager.current.fontColor
        shuffleToggle.layer.cornerRadius = shuffleToggle.frame.height / 2.0
        shuffleToggle.clipsToBounds = true
        shuffleToggle.backgroundColor = ThemeManager.current.lightColor
        shuffleToggle.onTintColor = ThemeManager.current.lightColor
        
        itemFirstLabel.textColor = ThemeManager.current.fontColor
        itemFirstCtrl.selectedSegmentTintColor = ThemeManager.current.backgroundColor.withAlphaComponent(0.25)
        itemFirstCtrl.backgroundColor = ThemeManager.current.lightColor
        confirmButton.tintColor = ThemeManager.current.secondaryColor
        editButton.tintColor = ThemeManager.current.secondaryColor
        deleteButton.tintColor = UIColor(red: 255/255, green: 50/255, blue: 50/255, alpha: 1.0)
        
        shuffleLabel.font = globalTextFont
        itemFirstLabel.font = globalTextFont
        itemFirstCtrl.setTitleTextAttributes([.font: globalTextFont, .foregroundColor: ThemeManager.current.fontColor], for: .normal)
        editButton.titleLabel?.font = globalButtonFont
        deleteButton.titleLabel?.font = globalButtonFont
        
        confirmButton.tintColor = ThemeManager.current.fontColor
        
    }
}
