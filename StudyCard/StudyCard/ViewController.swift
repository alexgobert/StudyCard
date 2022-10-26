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

//var setList:[CardSet] = [CardSet(name: "Test Set", terms: ["Canine"], definitions: ["Dog"])]

var setList:[String] = ["Hello", "World", "Search", "Bar"]

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var setsTableView: UITableView!
    @IBOutlet weak var setSearch: UISearchBar!
    
//    var searchData: [CardSet]!
    
    var searchData: [String] = setList
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setsTableView.delegate = self
        setsTableView.dataSource = self
        setSearch.delegate = self
        
        searchData = setList
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: setTextCellIdentifier, for: indexPath)
//        cell.textLabel?.text = setList[indexPath.row].name
        cell.textLabel?.text = searchData[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("test")
        searchData = searchText.isEmpty ? setList : setList.filter { (item: String) -> Bool in
                return item.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
            }
            setsTableView.reloadData()
        }
    
//    func updateList(set: CardSet) {
//        setList.append(set)
//        setsTableView.reloadData()
//    }

}

