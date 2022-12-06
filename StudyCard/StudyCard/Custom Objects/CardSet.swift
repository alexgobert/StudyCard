//
//  CardSet.swift
//  StudyCard
//
//  Created by Alex Gobert on 10/11/22.
//

import Foundation
import CoreData

class CardSet: Collection, Equatable, CustomStringConvertible {
    var cards: [Card] = [] {
        didSet {
            endIndex = Swift.max(self.cards.count, 0)
        }
    }
    
    // initial values
    var name: String = ""
    var timesStudied: Int = 0
    var percentKnown: Float = 0.0
    
    // conformance to Collection
    var startIndex: Int = 0
    var endIndex: Int
    var count: Int { cards.count } // using Collection.count will soft lock code, this is an easy workaround
    
    // conformance to CustomStringConvertible
    var description: String { str() }
    
    // remember parent set for recursive percent setting
    var parent: CardSet!
    
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
    
    func updatePercent(knownCount: Int, totalCount: Int) {
        
        setPercentKnown(percent: Float(knownCount) / Float(totalCount))
        
    }
    
    static func == (lhs: CardSet, rhs: CardSet) -> Bool {
        return lhs.getName() == rhs.getName() && lhs.cards == rhs.cards
    }
    
    func getName() -> String {
        return name
    }
    
    func incrementTimesStudied(_ times: Int = 1) {
        timesStudied += times
    }
    
    func setTimesStudied(times: Int) {
        timesStudied = times
    }
    
    func setPercentKnown(percent: Float) {
        // take the highest known value up to 100%
        percentKnown = percent
    }
    
    func getTimesStudied() -> Int {
        return timesStudied
    }
    
    func getPercentKnown() -> Float {
        return percentKnown
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
    
    func str() -> String {
        var string = name + "\n"
        
        string += "\tTimes Studied: \(getTimesStudied())\n"
        string += "\tPercentage Known: \(getPercentKnown())\n"
        
        return string
    }
    
    func updateStats(index: Int, newCount: Int, newPercent: Float, setContext: NSManagedObjectContext) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "StoredSet")
        var fetchedResults:[NSManagedObject]
        
        do {
            try fetchedResults = setContext.fetch(request) as! [NSManagedObject]
            
            fetchedResults[index].setValue(newCount, forKey: "timesStudied")
            fetchedResults[index].setValue(newPercent, forKey: "percentKnown")
            
        } catch {
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        
        saveContext()
        
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
