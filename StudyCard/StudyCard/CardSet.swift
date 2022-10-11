//
//  CardSet.swift
//  StudyCard
//
//  Created by Alex Gobert on 10/11/22.
//

class CardSet {
    var set: [Card] = []
    
    init(set: [Card]?) {
        self.set = set ?? self.set
    }
    
    convenience init() {
        self.init(set: nil)
    }
    
    init(terms: [String], definitions: [String]) {
        self.set = zip(terms, definitions).map(
            { (term: String, definition: String) -> Card
                in return Card(term: term, definition: definition) }
        )
    }
}
