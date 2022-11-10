//
//  ViewController.swift
//  StudyCard
//
//  Created by A Horvath on 10/10/22.
//

import UIKit
import FirebaseAuth

let setTextCellIdentifier = "SetNameCell"

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, StudyListUpdater {
    
    @IBOutlet weak var setsTableView: UITableView!
    @IBOutlet weak var setSearch: UISearchBar!
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    @IBOutlet weak var profileButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    var setList:[CardSet]! = []
    var searchData: [CardSet]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setsTableView.delegate = self
        setsTableView.dataSource = self
        setSearch.delegate = self
        
        searchData = setList
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert]) {
            granted, error in
            if granted {
                ()
            } else {
                DispatchQueue.main.async {
                    do {
                        try Auth.auth().signOut()
                        self.performSegue(withIdentifier: "NoPermission", sender: nil)
                        
                        let controller = UIAlertController(
                            title: "Permission Denied",
                            message: "Notification Permissions were denied. Please enable this through settings",
                            preferredStyle: .alert)
                        controller.addAction(UIAlertAction(
                            title: "Return",
                            style: .default,
                            handler: nil))
                        self.present(controller, animated: true)
                        
                    } catch {
                        print("Sign out error")
                    }
                }
            }
        }
        
        sendNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // theme compliance
        self.navigationController?.navigationBar.tintColor = globalFontColor
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
    
    func sendNotification() {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Message from StudyCard:"
        notificationContent.body = "Don't forget to study for your upcoming exams!"
        notificationContent.badge = NSNumber(value: 1)
        notificationContent.sound = .default
                        
        var notificationTime = DateComponents()
        notificationTime.hour = 8
        notificationTime.minute = 0
        let trigger = UNCalendarNotificationTrigger(dateMatching: notificationTime, repeats: true)
        let request = UNNotificationRequest(identifier: "ID", content: notificationContent, trigger: trigger)
                        UNUserNotificationCenter.current().add(request) { (error : Error?) in
                            if let message = error {
                                print(message.localizedDescription)
            }
        }
    }
    
    func updateList(set: CardSet) {
        setList.append(set)
        searchData = setList
        setsTableView.reloadData()
    }
}

