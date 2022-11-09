//
//  SetCreationVC.swift
//  StudyCard
//
//  Created by Alex Gobert on 10/11/22.
//

import UIKit

class SetCreationVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var currentSet: CardSet!
    var delegate: StudyListUpdater!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        // set variable height for rows
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableView.automaticDimension
        
        titleField.tag = -1 // only title field has -1 tag
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // initialize empty card set
        currentSet = CardSet(name: nil, cards: nil)
        
        // set theme
        view.backgroundColor = globalBkgdColor
        titleField.font = globalFont
    }
    
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        if !currentSet.isEmpty(), let title = titleField.text {
            currentSet.name = title
            delegate.updateList(set: currentSet)
            
            self.navigationController?.popViewController(animated: true)
        } else {
            print("save error") // TODO add status label
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentSet.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldTableViewCell", for: indexPath) as! TextFieldTableViewCell
        
        cell.setTags(indexPath.row)
        cell.setFont(globalFont)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            currentSet.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // enters guard clause if text field is the title field
        guard textField.tag != -1 else {
            currentSet.name = textField.text!
            return
        }
        
        let index = NSIndexPath(row: textField.tag, section: 0) as IndexPath
        if let cell = tableView.cellForRow(at: index) as? TextFieldTableViewCell,
           let term = cell.getTerm(),
           let def = cell.getDefinition() {
            currentSet.addCard(term: term, definition: def)
        }
    }

}
