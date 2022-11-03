//
//  SetCreationVC.swift
//  StudyCard
//
//  Created by Alex Gobert on 10/11/22.
//

import UIKit

class SetCreationVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // initialize empty card set
        currentSet = CardSet(name: nil, cards: nil)
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
        
        if let term = cell.getTerm(), let definition = cell.getDefinition() {
            currentSet.addCard(card: Card(term: term, definition: definition))
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            currentSet.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

}
