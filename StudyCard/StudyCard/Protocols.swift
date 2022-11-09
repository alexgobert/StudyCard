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
    func setTags(_ tag: Int)
    func setFont(_ font: UIFont)
}
