//
//  ViewController.swift
//  StudyCard
//
//  Created by A Horvath on 10/10/22.
//

import UIKit

let setTextCellIdentifier = "SetNameCell"

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, StudyListUpdater {
    
    @IBOutlet weak var setsTableView: UITableView!
    @IBOutlet weak var setSearch: UISearchBar!
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    @IBOutlet weak var profileButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    var setList:[CardSet]! = [CardSet(name: "Test Set", terms: ["Canine"], definitions: ["Dog"])]
    var searchData: [CardSet]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchData = setList
        
        setsTableView.delegate = self
        setsTableView.dataSource = self
        setSearch.delegate = self
        
        self.navigationController?.navigationBar.tintColor = globalFontColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.backgroundColor = globalBkgdColor
        
        setsTableView.backgroundColor = globalBkgdColor
        setsTableView.separatorColor = globalFontColor
        
        setSearch.barTintColor = globalBkgdColor
        setSearch.searchTextField.leftView?.tintColor = globalFontColor
        setSearch.searchTextField.font = globalFont
        setSearch.searchTextField.textColor = globalFontColor
        
        settingsButton.tintColor = globalFontColor
        profileButton.tintColor = globalFontColor
        addButton.tintColor = globalFontColor
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SetCreationSegue", let dest = segue.destination as? SetCreationVC {
            dest.delegate = self
        } else if segue.identifier == "StudySetupSegue", let dest = segue.destination as? StudySetupVC, let index = setsTableView.indexPathForSelectedRow?.row {
            dest.cards = setList[index]
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: setTextCellIdentifier, for: indexPath)
        cell.textLabel?.text = setList[indexPath.row].name
        cell.textLabel?.font = globalFont
        cell.textLabel?.textColor = globalFontColor
        cell.backgroundColor = globalBkgdColor
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchData = searchText.isEmpty ? setList : setList.filter { (item: CardSet) -> Bool in
            return item.name.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
                }
                setsTableView.reloadData()
            }
    
    func updateList(set: CardSet) {
        setList.append(set)
        setsTableView.reloadData()
    }
}

