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
        self.termField.backgroundColor = globalSecondaryColor
        self.termField.textColor = globalFontColor
        self.definitionField.backgroundColor = globalSecondaryColor
        self.definitionField.textColor = globalFontColor
        self.termField.attributedPlaceholder = NSAttributedString(
            string: "Term",
            attributes: [NSAttributedString.Key.foregroundColor: globalFontColor.withAlphaComponent(0.50)])
        self.definitionField.attributedPlaceholder = NSAttributedString(
            string: "Definition",
            attributes: [NSAttributedString.Key.foregroundColor: globalFontColor.withAlphaComponent(0.50)])
    }

}
