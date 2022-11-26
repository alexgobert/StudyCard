//
//  SwitchTableViewCell.swift
//  StudyCard
//
//  Created by Chris Tran on 11/10/22.
//

import UIKit

class SwitchTableViewCell: UITableViewCell {
    static let identifier = "SwitchTableViewCell"
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    private let mySwitch: UISwitch = {
        let mySwitch = UISwitch()
        return mySwitch
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(label)
        contentView.addSubview(mySwitch)
        contentView.clipsToBounds = true
        accessoryType = .none
        accessoryView = mySwitch
        mySwitch.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
    }
    
    @objc func valueChanged(sender: UISwitch) {
        if sender.isOn == true{
            userDefaults.set(true, forKey: toggleKeys[label.text ?? ""] ?? "")
        } else {
            userDefaults.set(false, forKey: toggleKeys[label.text ?? ""] ?? "")
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.frame = CGRect(
            x: 20,
            y: 0,
            width: contentView.frame.size.width - 15,
            height: contentView.frame.size.height
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        label.text = nil
        label.font = nil
        label.textColor = nil
        mySwitch.onTintColor = nil
        mySwitch.isOn = false
    }
    
    public func configure(with model: SettingsSwitchOption) {
        label.text = model.title
        label.font = model.font
        label.textColor = model.fontColor
        mySwitch.layer.cornerRadius = mySwitch.frame.height / 2.0
        mySwitch.clipsToBounds = true
        mySwitch.backgroundColor = model.backgroundColor
        mySwitch.onTintColor = model.switchColor
        mySwitch.isOn = model.isOn
    }

}
