//
//  SettingTableViewCell.swift
//  StudyCard
//
//  Created by Chris Tran on 11/10/22.
//

import UIKit

class SettingTableViewCell: UITableViewCell {
    static let identifier = "SettingTableViewCell"
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        contentView.clipsToBounds = true
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
            height: contentView.frame.size.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        label.font = nil
        label.textColor = nil
    }
    
    public func configure(with model: SettingsOption) {
        label.text = model.title
        label.font = model.font
        label.textColor = model.fontColor
    }

}
