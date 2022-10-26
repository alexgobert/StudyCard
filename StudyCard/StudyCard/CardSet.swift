//
//  CardSet.swift
//  StudyCard
//
//  Created by Alex Gobert on 10/11/22.
//

class CardSet {
    var set: [Card] = []
    var name: String = ""
    
    init(set: [Card]?) {
        self.set = set ?? self.set
    }
    
    convenience init() {
        self.init(set: nil)
    }
    
    init(name: String, terms: [String], definitions: [String]) {
        self.name = name
        self.set = zip(terms, definitions).map(
            { (term: String, definition: String) -> Card
                in return Card(term: term, definition: definition) }
        )
    }
}
