//
//  ViewController.swift
//  StudyCard
//
//  Created by A Horvath on 10/10/22.
//

import UIKit

protocol StudyListUpdater {
    func updateList(set: CardSet)
}

let setTextCellIdentifier = "SetNameCell"

// var setList:[CardSet] = []

var setList:[String] = ["test"]

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var setsTableView: UITableView!
    @IBOutlet weak var setSearch: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setsTableView.delegate = self
        setsTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return setList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let outputStr = "Placholder"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: setTextCellIdentifier, for: indexPath)
        cell.textLabel?.text = outputStr
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
//    func updateList(set: CardSet) {
//        setList.append(set)
//        setsTableView.reloadData()
//    }

}

