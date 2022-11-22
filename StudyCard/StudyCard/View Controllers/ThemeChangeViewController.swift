//
//  ThemeChangeViewController.swift
//  StudyCard
//
//  Created by Chris Tran on 11/20/22.
//

import UIKit

public let themes = [
    "Default Theme",
    "Ocean Theme",
    "Sunshine Theme"
]

let themesList: [ThemeProtocol] = [DefaultTheme(), OceanTheme(), SunshineTheme()]

let themeCellIdentifier = "themeCell"

class ThemeChangeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationItem.title = "Theme"
        catchNotification()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: themeCellIdentifier, for: indexPath)
        cell.textLabel?.text = themes[row]
        cell.textLabel?.font = globalTextFont
        cell.textLabel?.textColor = globalFontColor
        cell.backgroundColor = globalLightColor
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        tableView.deselectRow(at: indexPath, animated: true)
        
        userDefaults.setColor(color: themesList[row].backgroundColor, forKey: BACKGROUND_COLOR_KEY)
        userDefaults.setColor(color: themesList[row].secondaryColor, forKey: SECONDARY_COLOR_KEY)
        userDefaults.setColor(color: themesList[row].lightColor, forKey: LIGHT_COLOR_KEY)
        userDefaults.setColor(color: themesList[row].fontColor, forKey: FONT_COLOR_KEY)
        
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
        self.navigationController?.navigationBar.tintColor = globalFontColor
        self.view.backgroundColor = globalBkgdColor
        tableView.backgroundColor = globalBkgdColor
        tableView.separatorColor = globalFontColor
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = globalBkgdColor
                
        // This will alter the navigation bar title appearance
        appearance.titleTextAttributes = [.foregroundColor: globalFontColor]
        
        let button = UIBarButtonItemAppearance(style: .plain)
        button.normal.titleTextAttributes = [
            .font: globalBackButtonFont,
            .foregroundColor: globalFontColor
        ]
        appearance.buttonAppearance = button

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
}
