//
//  SummaryTableViewCell.swift
//  StudyCard
//
//  Created by Lynn Tran on 11/2/22.
//

import UIKit

class SummaryTableViewCell: UITableViewCell {

    @IBOutlet weak var termLabel: UILabel!
    @IBOutlet weak var definitionLabel: UILabel!
    
    var card: Card! {
        didSet {
            setTerm(card.getTerm())
            setDefinition(card.getDef())
        }
    }
    
    func setCard(_ card: Card) {
        self.card = card
    }
    
    func setTerm(_ term: String) {
        termLabel.text = term
    }
    
    func setDefinition(_ def: String) {
        termLabel.text = def
    }

}
