//
//  SummaryTableViewCell.swift
//  StudyCard
//
//  Created by Alex Gobert on 11/2/22.
//

import UIKit

class SummaryTableViewCell: UITableViewCell, CustomTableViewCell {

    @IBOutlet weak var termLabel: UILabel!
    @IBOutlet weak var definitionLabel: UILabel!
    
    func setCard(_ card: Card) {
        setTerm(card.getTerm())
        setDefinition(card.getDef())
    }
    
    func setTerm(_ term: String) {
        termLabel.text = term
    }
    
    func setDefinition(_ def: String) {
        definitionLabel.text = def
    }
    
    func setFont(_ font: UIFont) {
        // bold term label
        // https://stackoverflow.com/questions/16015916/how-do-i-create-a-bold-uifont-from-a-regular-uifont
        if let boldDescriptor = font.fontDescriptor.withSymbolicTraits(.traitBold) {
            termLabel.font = UIFont(descriptor: boldDescriptor, size: font.pointSize)
        }

        definitionLabel.font = font
    }
    
    func setColor(backgroundColor: UIColor, fontColor: UIColor) {
        self.backgroundColor = backgroundColor
        self.tintColor = backgroundColor
        termLabel.textColor = fontColor
        definitionLabel.textColor = fontColor
    }
    
    func setTags(_ tag: Int) {
        termLabel.tag = tag
        definitionLabel.tag = tag
    }

}
