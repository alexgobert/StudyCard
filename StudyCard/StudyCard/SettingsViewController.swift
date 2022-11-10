//
//  SettingsViewController.swift
//  StudyCard
//
//  Created by Chris Tran on 11/7/22.
//

import UIKit

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
    var isOn: Bool
    let handler: (() -> Void)
}

struct SettingsOption {
    let title: String
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
    }
    
    func configure() {
        models.append(Section(title: "Theme", options: [
            .staticCell(model: SettingsOption(title: "Font") {
                let fontController = UIAlertController(
                    title: "Font",
                    message: "Please select a font",
                    preferredStyle: .alert)
                fontController.addAction(UIAlertAction(
                    title: "Comic Sans",
                    style: .default))
                fontController.addAction(UIAlertAction(
                    title: "Helvetica",
                    style: .default))
                fontController.addAction(UIAlertAction(
                    title: "Times New Roman",
                    style: .default))
                fontController.addAction(UIAlertAction(
                    title: "Open Sans",
                    style: .default))
                fontController.addAction(UIAlertAction(
                    title: "SF Pro",
                    style: .default))
                fontController.addAction(UIAlertAction(
                    title: "Cancel",
                    style: .cancel))
                self.present(fontController, animated: true)
            }),
            .staticCell(model: SettingsOption(title: "Color") {
                
            })
        ]))
        
        models.append(Section(title: "Sounds", options: [
            .switchCell(model: SettingsSwitchOption(title: "Push notifications", isOn: true) {
                
            }),
            .switchCell(model: SettingsSwitchOption(title: "Volume Mute", isOn: true) {
                
            }),
            .switchCell(model: SettingsSwitchOption(title: "Vibrations", isOn: true) {
                
            })
        ]))
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = models[section]
        return section.title
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
            return settingsCell
        case .switchCell(let model):
            guard let settingsCell = tableView.dequeueReusableCell(withIdentifier: SwitchTableViewCell.identifier, for: indexPath) as? SwitchTableViewCell else {
                return UITableViewCell()
            }
            settingsCell.configure(with: model)
            return settingsCell
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
}
