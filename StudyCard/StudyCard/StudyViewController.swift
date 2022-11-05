//
//  StudyViewController.swift
//  StudyCard
//
//  Created by Sam Song on 10/19/22.
//


import UIKit

class StudyViewController: UIViewController {
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    var cards: CardSet!
    var itemFirst: String! // term, def, or mixed
    var knownCards: [Card]!
    var unknownCards: [Card]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        knownCards = []
        unknownCards = []
    }
    
    func studyDone() {
        performSegue(withIdentifier: "SummarySegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SummarySegue", let dest = segue.destination as? SummaryVC {
            dest.delegate = self
        }
    }
    
    func setCards(_ cards: CardSet) {
        self.cards = cards
    }
    
    // Right swipe Gesture
    @IBAction func rightGesture(_ sender: UISwipeGestureRecognizer) {
        print("Right")
    }
    
    // Left swipe Gesture
    @IBAction func leftGesture(_ sender: UISwipeGestureRecognizer) {
        print("Left")
    }
}
