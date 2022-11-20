//
//  Card.swift
//  StudyCard
//
//  Created by Alex Gobert on 10/11/22.
//

class Card: Equatable {
    var term: String = ""
    var definition: String = ""
    
    init(term: String?, definition: String?) {
        self.term = term ?? self.term
        self.definition = definition ?? self.definition
    }
    
    convenience init() {
        self.init(term: nil, definition: nil)
    }
    
    init(termDefTuple: (String, String)) {
        term = termDefTuple.0
        definition = termDefTuple.1
    }
    
    init(defTermTuple: (String, String)) {
        definition = defTermTuple.0
        term = defTermTuple.1
    }
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        lhs.getTerm() == rhs.getTerm() && lhs.getDef() == rhs.getDef()
    }
    
    func getTerm() -> String {
        return term
    }
    
    func getDef() -> String {
        return definition
    }
    
    func setTerm(_ newTerm: String) {
        term = newTerm
    }
    
    func setDef(_ newDefinition: String) {
        definition = newDefinition
    }
    
}
