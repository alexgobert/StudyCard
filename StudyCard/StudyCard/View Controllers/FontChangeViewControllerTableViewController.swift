//
//  FontChangeViewControllerTableViewController.swift
//  StudyCard
//
//  Created by Chris Tran on 11/21/22.
//

import UIKit

public let fonts: [String] = [
    "Courier New",
    "Didot",
    "Helvetica",
    "Hoefler Text",
    "Times New Roman",
    "Verdana"
]

let officialFontNames: [String] = [
    "CourierNewPSMT",
    "Didot",
    "Helvetica",
    "HoeflerText-Regular",
    "TimesNewRomanPSMT",
    "Verdana"
]

let fontCellIdentifier = "fontCell"

class FontChangeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationItem.title = "Font"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // theme compliance
        applyTheme()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fonts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: fontCellIdentifier, for: indexPath)
        cell.textLabel?.text = fonts[row]
        cell.textLabel?.font = globalTextFont
        cell.textLabel?.textColor = ThemeManager.current.fontColor
        cell.backgroundColor = ThemeManager.current.lightColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        tableView.deselectRow(at: indexPath, animated: true)
        
        userDefaults.set(officialFontNames[row], forKey: FONT_KEY)
        
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
        tableView.separatorColor = ThemeManager.current.fontColor
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = ThemeManager.current.backgroundColor
                
        // This will alter the navigation bar title appearance
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: ThemeManager.current.fontColor]
        
        let button = UIBarButtonItemAppearance(style: .plain)
            button.normal.titleTextAttributes = [NSAttributedString.Key.font: globalBackButtonFont!, NSAttributedString.Key.foregroundColor: ThemeManager.current.fontColor]
        appearance.buttonAppearance = button

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
}
