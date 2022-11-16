//
//  ViewController.swift
//  StudyCard
//
//  Created by A Horvath on 10/10/22.
//

import UIKit
import FirebaseAuth
import CoreData

let setTextCellIdentifier = "SetNameCell"

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, StudyListUpdater {
    
    @IBOutlet weak var setsTableView: UITableView!
    @IBOutlet weak var setSearch: UISearchBar!
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    @IBOutlet weak var profileButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    var setList: [CardSet] = []
    var searchData: [CardSet]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setsTableView.delegate = self
        setsTableView.dataSource = self
        setSearch.delegate = self
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert]) {
            granted, error in
            if !granted {
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
                        self.errorAlert(message: "Sign out error")
                    }
                }
            }
        }
        
        for set in retrieveSet() {
            let setTitle = set.value(forKey: "name")
            let termsData = set.value(forKey: "terms")
            let definitionsData = set.value(forKey: "definitions")

            let terms: [String] = try! JSONDecoder().decode([String].self, from: termsData! as! Data)
            let definitions: [String] = try! JSONDecoder().decode([String].self, from: definitionsData! as! Data)

            setList.append(CardSet(name: setTitle as! String, terms: terms, definitions: definitions))

        }
        
        searchData = setList
        
        sendNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setsTableView.reloadData()
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: setTextCellIdentifier, for: indexPath) as! SetListCell
        
        cell.setName(setName: setList[indexPath.row].getName())
        cell.setTimes(times: setList[indexPath.row].getTimesStudied())
        cell.setPercent(percent: setList[indexPath.row].getPercentKnown())
//        cell.textLabel?.font = globalFont
//        cell.textLabel?.textColor = globalFontColor
//        cell.backgroundColor = globalBkgdColor
        
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
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            setList.remove(at: indexPath.row)
//            searchData = setList
//            tableView.deleteRows(at: [indexPath], with: .fade)
//
//            deleteItem(setNum: indexPath.row)
//        }
//    }
    
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
        UNUserNotificationCenter.current().add(request) {
                (error : Error?) in
                if let error = error {
                    self.errorAlert(message: error.localizedDescription)
                }
        }
    }
    
    func retrieveSet() -> [NSManagedObject] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "StoredSet")
        var fetchedResults:[NSManagedObject]? = nil
        
        do {
            try fetchedResults = context.fetch(request) as? [NSManagedObject]
        } catch {
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        
        return(fetchedResults)!
    }
    
    func deleteItem(setNum: Int) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "StoredSet")
        var fetchedResults:[NSManagedObject]
        
        do {
            try fetchedResults = context.fetch(request) as! [NSManagedObject]
            
            context.delete(fetchedResults[setNum] as NSManagedObject)
            
        } catch {
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
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
                errorAlert(message: nserror.localizedDescription)
            }
        }
    }
    
    func updateList(set: CardSet) {
        setList.append(set)
        searchData = setList
    }
}

