//
//  TextFieldTableViewCell.swift
//  StudyCard
//
//  Created by Alex Gobert on 10/11/22.
//

import UIKit

class TextFieldTableViewCell: UITableViewCell, CustomTableViewCell {
    
    @IBOutlet weak var termField: UITextField!
    @IBOutlet weak var definitionField: UITextField!
    
    func getTerm() -> String? {
        return termField?.text
    }
    
    func getDefinition() -> String? {
        return definitionField?.text
    }
    
    func setFont(_ font: UIFont) {
        termField.font = font
        definitionField.font = font
    }
    
    func setColor(_ color: UIColor) {
        self.backgroundColor = color
        self.tintColor = color
    }

}
