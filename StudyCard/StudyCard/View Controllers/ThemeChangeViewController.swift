//
//  ThemeChangeViewController.swift
//  StudyCard
//
//  Created by Chris Tran on 11/20/22.
//

import UIKit

public let fonts: [String] = [
    "Comic Sans",
    "Helvetica",
    "Times New Roman",
    "Open Sans",
    "SF Pro",
]

let themes = [
    "Default Theme",
    "Ocean Theme",
    "Sunshine Theme"
]

let textCellIdentifier = "TextCell"

class ThemeChangeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // theme compliance
        applyTheme()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return themes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath)
        cell.textLabel?.text = themes[row]
        cell.textLabel?.textColor = ThemeManager.current.fontColor
        cell.backgroundColor = ThemeManager.current.backgroundColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        tableView.deselectRow(at: indexPath, animated: true)
        ThemeManager.current = ThemeManager.themes[row]
        NotificationCenter.default.post(name: NSNotification.Name("ThemeUpdate"), object: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    func catchNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTheme), name: NSNotification.Name("ThemeUpdate"), object: nil)
    }
    
    @objc func reloadTheme() {
        applyTheme()
    }
    
    func applyTheme() {
        self.navigationController?.navigationBar.tintColor = ThemeManager.current.fontColor
        self.view.backgroundColor = ThemeManager.current.backgroundColor
        tableView.backgroundColor = ThemeManager.current.backgroundColor
        tableView.separatorColor = ThemeManager.current.secondaryColor
    }
}
