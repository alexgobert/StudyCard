//
//  SetCreationVC.swift
//  StudyCard
//
//  Created by Alex Gobert on 10/11/22.
//

import UIKit
import CoreData

class SetCreationVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var addTermButton: UIButton!
    
    var delegate: StudyListUpdater!
    var cellCount: Int = 1
    var cardSet: [Card]!
    var importedSet: CardSet!
    var setIndex: Int!
    var editingSet: Bool!
    var context: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        // set variable height for rows
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableView.automaticDimension
        
        catchNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cardSet = [Card()]
        
        // set theme
        applyTheme()
        
        if importedSet != nil {
            cardSet.remove(at: 0)
            for card in importedSet.cards {
                cardSet.append(card)
            }
            
            titleField.text = importedSet.name
            
        }
        
    }
    
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        let emptyField = missingField()
        
        if emptyField {
            let controller = UIAlertController(
                title: "Missing Field",
                message: "Please make sure to enter every term and definition",
                preferredStyle: .alert)
            controller.addAction(UIAlertAction(
                title: "Return",
                style: .default,
                handler: nil))
            present(controller, animated: true)
            
        } else if titleField.text == "" {
            let controller = UIAlertController(
                title: "Missing Title",
                message: "Please enter a title",
                preferredStyle: .alert)
            controller.addAction(UIAlertAction(
                title: "Return",
                style: .default,
                handler: nil))
            present(controller, animated: true)
            
        } else {
            let otherVC = delegate as! ViewController
            let cellList = self.tableView.visibleCells as! [TextFieldTableViewCell]
            otherVC.updateList(set: CardSet(name: titleField.text, cards: cardSet), index: setIndex)
            
            // enure that all terms and definitions are stored to cells
            var i = 0
            for cell in cellList {
                cardSet[i].term = cell.getTerm()!
                cardSet[i].definition = cell.getDefinition()!
                
                i += 1
            }
            
            storeSet(name: titleField.text!, cards: cardSet)
            
            self.navigationController?.popViewController(animated: true)
            
            if editingSet {
                self.navigationController?.popViewController(animated: true)
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardSet.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldTableViewCell", for: indexPath) as! TextFieldTableViewCell
        
        cell.termField.text = cardSet[indexPath.row].getTerm()
        cell.definitionField.text = cardSet[indexPath.row].getDef()
        
        
        cell.setColor(globalBkgdColor)
        cell.setFont(globalTextFont)
        
        let selectedCellView: UIView = UIView()
        selectedCellView.backgroundColor = globalSecondaryColor
        cell.selectedBackgroundView = selectedCellView
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            cardSet.remove(at: indexPath.row)
            let deletedCell = tableView.cellForRow(at: indexPath) as! TextFieldTableViewCell
            deletedCell.termField.text = ""
            deletedCell.definitionField.text = ""
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        let emptyField = missingField()
        
        if emptyField {
            let controller = UIAlertController(
                title: "Missing Field",
                message: "Please make sure to enter every term and definition",
                preferredStyle: .alert)
            controller.addAction(UIAlertAction(
                title: "Return",
                style: .default,
                handler: nil))
            present(controller, animated: true)
            
        } else {
            addCard()
        }
    }
    
    func missingField() -> Bool {
        let cellList = self.tableView.visibleCells as! [TextFieldTableViewCell]
        
        var emptyField = false
        
        for cell in cellList {
            if cell.getTerm() == "" || cell.getDefinition() == "" {
                emptyField = true
                break
            }
        }
        
        return emptyField
        
    }
    
    func addCard() {
        let cellList = self.tableView.visibleCells as! [TextFieldTableViewCell]
        
        var i = 0
        for cell in cellList {
            cardSet[i].term = cell.getTerm()!
            cardSet[i].definition = cell.getDefinition()!
            
            i += 1
        }
        
        cardSet.append(Card(term: nil, definition: nil))
        tableView.reloadData()
        
    }
    
    func storeSet(name: String, cards: [Card]) {
        var terms: [String] = []
        var defs: [String] = []
        
        for card in cards {
            terms.append(card.term)
            defs.append(card.definition)
        }
        
        let termsString: String = terms.description
        let defsString: String = defs.description
        let termsData = termsString.data(using: String.Encoding.utf8)
        let defsData = defsString.data(using: String.Encoding.utf8)
        
        if editingSet {
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "StoredSet")
            var fetchedResults:[NSManagedObject]
            
            do {
                try fetchedResults = context.fetch(request) as! [NSManagedObject]
                
                fetchedResults[setIndex].setValue(name, forKey: "name")
                fetchedResults[setIndex].setValue(termsData, forKey: "terms")
                fetchedResults[setIndex].setValue(defsData, forKey: "definitions")
                fetchedResults[setIndex].setValue(0, forKey: "timesStudied")
                fetchedResults[setIndex].setValue(0, forKey: "percentKnown")
                
            } catch {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
            
            
        } else {
            let set = NSEntityDescription.insertNewObject(forEntityName: "StoredSet", into: context)
            
            set.setValue(name, forKey: "name")
            set.setValue(termsData, forKey: "terms")
            set.setValue(defsData, forKey: "definitions")
            set.setValue(0, forKey: "timesStudied")
            set.setValue(0, forKey: "percentKnown")
            
        }
        
        saveContext()
        
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
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
        self.view.backgroundColor = globalBkgdColor
        tableView.backgroundColor = globalBkgdColor
        addTermButton.tintColor = globalSecondaryColor
        saveButton.tintColor = globalSecondaryColor
        titleField.font = globalTextFont
        titleField.backgroundColor = globalSecondaryColor
        titleField.textColor = globalFontColor
        titleField.attributedPlaceholder = NSAttributedString(
            string: "Title",
            attributes: [NSAttributedString.Key.foregroundColor: globalFontColor.withAlphaComponent(0.50)])
        
    }

}
