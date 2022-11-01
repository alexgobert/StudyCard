//
//  CardSet.swift
//  StudyCard
//
//  Created by Alex Gobert on 10/11/22.
//

class CardSet: Collection {
    var set: [Card] = []
    var name: String = ""
    
    // conformance to Collection
    var startIndex: Index = 0
    var endIndex: Index
    
    init(name: String?, set: [Card]?) {
        self.name = name ?? self.name
        self.set = set ?? self.set
        
        endIndex = max(self.set.count, 0)
    }
    
    convenience init() {
        self.init(name: nil, set: nil)
    }
    
    init(name: String, terms: [String], definitions: [String]) {
        self.name = name
        self.set = zip(terms, definitions).map(
            { (term: String, definition: String) -> Card
                in return Card(term: term, definition: definition) }
        )
    }
    
    func addCard(card: Card) {
        set.append(card)
        endIndex += 1
    }
    
    func remove(at index: Int) {
        set.remove(at: index)
    }
    
    func index(after i: Index) -> Index {
        return min(startIndex + 1, endIndex - 1)
    }
}
