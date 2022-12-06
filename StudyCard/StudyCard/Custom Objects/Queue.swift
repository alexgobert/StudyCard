//
//  Queue.swift
//  StudyCard
//
//  Created by Alex Gobert on 12/5/22.
//

struct Queue<T> {
    private var elements: [T] = []
    
    mutating func enqueue(_ value: T) {
        elements.append(value)
    }
    
    mutating func dequeue() -> T? {
        guard !elements.isEmpty else {
            return nil
        }
        
        return elements.removeFirst()
    }
    
    func peek() -> T? {
        guard !elements.isEmpty else {
            return nil
        }
        
        return elements[0]
    }
}
