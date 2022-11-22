//
//  Protocols.swift
//  StudyCard
//
//  Created by Alex Gobert on 11/2/22.
//

import UIKit

protocol StudyListUpdater {
    func updateList(set: CardSet, index: Int?)
}

protocol CustomTableViewCell {
    func setFont(_ font: UIFont)
}

protocol DeleteList {
    func deleteItem(cardSet: CardSet)
}

protocol ThemeProtocol {
    var fontColor: UIColor { get set }
    var backgroundColor: UIColor { get set }
    var lightColor: UIColor { get set }
    var secondaryColor: UIColor { get set }
}

protocol DefaultInitializable {
  init()
}

protocol UserDefaultsPeristable: Codable, DefaultInitializable {
    static var key: String {get}
}
