//
//  Protocols.swift
//  StudyCard
//
//  Created by Alex Gobert on 11/2/22.
//

import UIKit

protocol StudyListUpdater {
    func updateList(set: CardSet)
}

protocol CustomTableViewCell {
    func setFont(_ font: UIFont)
}

protocol DeleteList {
    func deleteItem(cardSet: CardSet)
}
