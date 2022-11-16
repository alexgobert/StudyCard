//
//  CardSet.swift
//  StudyCard
//
//  Created by Alex Gobert on 10/11/22.
//

class CardSet: Collection {
    var cards: [Card] = [] {
        didSet {
            endIndex = Swift.max(self.cards.count, 0)
        }
    }
    var name: String = ""
    
    // conformance to Collection
    var startIndex: Int = 0
    var endIndex: Int
    
    init(name: String?, cards: [Card]?) {
        self.name = name ?? self.name
        self.cards = cards ?? self.cards
        
        endIndex = Swift.max(self.cards.count, 0)
    }
    
    convenience init() {
        self.init(name: nil, cards: nil)
    }
    
    init(name: String, terms: [String], definitions: [String]) {
        self.name = name
        cards = zip(terms, definitions).map(
            { (term: String, definition: String) -> Card
                in return Card(term: term, definition: definition) }
        )
        
        endIndex = Swift.max(self.cards.count, 0)
    }
    
    func isEmpty() -> Bool {
        return cards.count == 0
    }
    
    func addCard(card: Card) {
        cards.append(card)
    }
    
    func addCard(term: String, definition: String) {
        self.addCard(card: Card(termDefTuple: (term, definition)))
    }
    
    func remove(at index: Int) {
        cards.remove(at: index)
    }
    
    // conformance to Collection
    subscript(position: Int) -> Card {
        get { return cards[position] }
    }
    
    // conformance to Collection
    func index(after i: Int) -> Int {
        return Swift.min(startIndex + 1, endIndex - 1)
    }
    
    func shuffle(_ doShuffle: Bool?) {
        let shuff = doShuffle ?? true
        if shuff {
            cards.shuffle()
        }
    }
}
