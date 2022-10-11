//
//  TextFieldTableViewCell.swift
//  StudyCard
//
//  Created by Alex Gobert on 10/11/22.
//

import UIKit

class TextFieldTableViewCell: UITableViewCell {

    
    @IBOutlet weak var termField: UITextField!
    @IBOutlet weak var definitionField: UITextField!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var deleteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // set constraints on stack view
        stackView.leadingAnchor
            .constraint(
                equalToSystemSpacingAfter: self.leadingAnchor,
                multiplier: 0.1)
            .isActive = true
        stackView.trailingAnchor
            .constraint(
                equalToSystemSpacingAfter: deleteButton.trailingAnchor,
                multiplier: 0.1)
            .isActive = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func deletedPressed(_ sender: UIButton) {
    }
    
    func getTerm() -> String? {
        return termField?.text
    }
    
    func getDefinition() -> String? {
        return definitionField?.text
    }

}
