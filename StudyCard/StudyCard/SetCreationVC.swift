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
    var font: UIFont!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        // initialize empty card set
        currentSet = CardSet(name: titleField.text)
        
        // set variable height for rows
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldTableViewCell", for: indexPath) as! TextFieldTableViewCell
        
        if let term = cell.getTerm(), let definition = cell.getDefinition() {
            currentSet.addCard(card: Card(term: term, definition: definition))
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            currentSet.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

}
