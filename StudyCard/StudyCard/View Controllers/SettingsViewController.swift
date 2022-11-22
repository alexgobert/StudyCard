//
//  SettingsViewController.swift
//  StudyCard
//
//  Created by Chris Tran on 11/7/22.
//

import UIKit

let userDefaults = UserDefaults.standard
let muteKey = "muteKey"
let vibrationKey = "vibrationKey"
let notifKey = "notificationKey"

let BACKGROUND_COLOR_KEY = "backgroundColorKey"
let SECONDARY_COLOR_KEY = "secondaryColorKey"
let FONT_COLOR_KEY = "fontColorKey"
let FONT_KEY = "fontKey"

struct Section {
    let title: String
    let options: [SettingsOptionType]
}

enum SettingsOptionType {
    case staticCell(model: SettingsOption)
    case switchCell(model: SettingsSwitchOption)
}

struct SettingsSwitchOption {
    let title: String
    let font: UIFont
    let fontColor: UIColor
    var isOn: Bool
    let handler: (() -> Void)
}

struct SettingsOption {
    let title: String
    let font: UIFont
    let fontColor: UIColor
    let handler: (() -> Void)
}

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
        table.register(SwitchTableViewCell.self, forCellReuseIdentifier: SwitchTableViewCell.identifier)
        return table
    }()
    
    var models = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.title = "Settings"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // theme compliance
        applyTheme()
        tableView.reloadData()
    }
    
    func configure() {
        models.append(Section(title: "Theme", options: [
            .staticCell(model: SettingsOption(title: "Font", font: globalTextFont, fontColor: ThemeManager.current.fontColor) {
                self.performSegue(withIdentifier: "fontSegue", sender: self)
            }),
            .staticCell(model: SettingsOption(title: "Theme", font: globalTextFont, fontColor: ThemeManager.current.fontColor) {
                self.performSegue(withIdentifier: "themeSegue", sender: self)
            })
        ]))
        
        models.append(Section(title: "Sounds", options: [
            .switchCell(model: SettingsSwitchOption(title: "Push Notifications", font: globalTextFont, fontColor: ThemeManager.current.fontColor, isOn: true) {
                
            }),
            .switchCell(model: SettingsSwitchOption(title: "Volume Mute", font: globalTextFont, fontColor: ThemeManager.current.fontColor, isOn: true) {
                
            }),
            .switchCell(model: SettingsSwitchOption(title: "Vibrations", font: globalTextFont, fontColor: ThemeManager.current.fontColor, isOn: true) {
                
            })
        ]))
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = models[section]
        return section.title
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = ThemeManager.current.fontColor
        header.textLabel?.font = globalTextFont
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.section].options[indexPath.row]
        
        switch model.self {
        case .staticCell(let model):
            guard let settingsCell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.identifier, for: indexPath) as? SettingTableViewCell else {
                return UITableViewCell()
            }
            settingsCell.configure(with: model)
            settingsCell.backgroundColor = ThemeManager.current.lightColor
            settingsCell.preservesSuperviewLayoutMargins = false
            settingsCell.separatorInset = UIEdgeInsets.zero
            settingsCell.layoutMargins = UIEdgeInsets.zero
            return settingsCell
        case .switchCell(let model):
            guard let switchCell = tableView.dequeueReusableCell(withIdentifier: SwitchTableViewCell.identifier, for: indexPath) as? SwitchTableViewCell else {
                return UITableViewCell()
            }
            switchCell.configure(with: model)
            switchCell.backgroundColor = ThemeManager.current.lightColor
            switchCell.preservesSuperviewLayoutMargins = false
            switchCell.separatorInset = UIEdgeInsets.zero
            switchCell.layoutMargins = UIEdgeInsets.zero
            return switchCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let type = models[indexPath.section].options[indexPath.row]
        switch type.self {
        case .staticCell(let model):
            model.handler()
        case .switchCell(let model):
            model.handler()
        }
    }
    
    func catchNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTheme), name: NSNotification.Name("ThemeUpdate"), object: nil)
    }
    
    @objc func reloadTheme() {
        applyTheme()
    }
    
    func applyTheme() {
        models.removeAll()
        configure()
        
        // changes color
        self.view.backgroundColor = ThemeManager.current.backgroundColor
        tableView.backgroundColor = ThemeManager.current.backgroundColor
        tableView.separatorColor = ThemeManager.current.fontColor
        tableView.tintColor = ThemeManager.current.fontColor
        
        // alters the navigation bar title appearance
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = ThemeManager.current.backgroundColor
        appearance.titleTextAttributes = [NSAttributedString.Key.font: globalBackButtonFont ,NSAttributedString.Key.foregroundColor: ThemeManager.current.fontColor]
        appearance.largeTitleTextAttributes = [NSAttributedString.Key.font: globalTitleFont ,NSAttributedString.Key.foregroundColor: ThemeManager.current.fontColor]
        
        let button = UIBarButtonItemAppearance(style: .plain)
            button.normal.titleTextAttributes = [NSAttributedString.Key.font: globalBackButtonFont, NSAttributedString.Key.foregroundColor: ThemeManager.current.fontColor]
        appearance.buttonAppearance = button

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        self.navigationController?.navigationBar.tintColor = ThemeManager.current.secondaryColor
        
    }
}
