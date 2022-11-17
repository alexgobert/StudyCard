//
//  StudyViewController.swift
//  StudyCard
//
//  Created by Sam Song on 10/19/22.
//


import UIKit

class StudyViewController: UIViewController {
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var knownLabel: UILabel!
    @IBOutlet weak var unknownLabel: UILabel!
    @IBOutlet weak var swipeLabel: UILabel!
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var cardLabel: UILabel!
    
    var cardSet: CardSet!
    var itemFirst: String! // term, def, or mixed
    var currentCard: Card?
    var isShowingTerm: Bool = true
    var remainingCards: [Card]!
    var knownCards: [Card]!
    var unknownCards: [Card]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let currentCard = cardSet.cards.first else { return }
        self.currentCard = currentCard
        cardLabel.text = currentCard.term
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapCard))
        cardView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func didTapCard() {
        guard let currentCard = currentCard else { return }
        cardLabel.text = isShowingTerm ? currentCard.definition : currentCard.term
        UIView.transition(with: cardView,
                          duration: 1,
                          options: isShowingTerm ? .transitionFlipFromRight : .transitionFlipFromLeft,
                          animations: nil,
                          completion: nil)
        isShowingTerm.toggle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        remainingCards = cardSet.cards
        knownCards = []
        unknownCards = []
        
        // theme compliance
        view.backgroundColor = globalBkgdColor
        
        // theme compliance
        let labels: [UILabel] = [
            knownLabel,
            unknownLabel,
            swipeLabel
        ]
        for label in labels {
            label.font = globalFont
        }
    }
    
    func studyDone() {
        performSegue(withIdentifier: "SummarySegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SummarySegue", let dest = segue.destination as? SummaryVC {
            dest.delegate = self
        }
    }
    
    func setCards(_ cardSet: CardSet) {
        self.cardSet = cardSet
    }
    
    // Right swipe Gesture
    @IBAction func rightGesture(_ sender: UISwipeGestureRecognizer) {
        print("Right")
        print("don't know it")
        if let currentCard = currentCard {
            unknownCards.append(currentCard)
            remainingCards.removeAll(where: {
                $0.term == currentCard.term && $0.definition == currentCard.definition
            })
//            if remainingCards.isEmpty {
//                cardView.isHidden = true
//                cardLabel.isHidden = true
//            }
            let startingX = self.cardView.center.x
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 1, delay: 0, animations: {
                self.cardView.center.x += 2*UIScreen.main.bounds.width
                self.view.layoutIfNeeded()
            }, completion: {_ in
                self.cardView.center.x = -2*UIScreen.main.bounds.width
                self.view.layoutIfNeeded()
                UIView.animate(withDuration: 1, delay: 0, animations: {
                    self.cardView.center.x = startingX
                    //self.cardLabel.text = "New Term"
                    self.view.layoutIfNeeded()
                })
            })
        }
    }
    
    // Left swipe Gesture
    @IBAction func leftGesture(_ sender: UISwipeGestureRecognizer) {
        print("Left")
        print("know it")
        if let currentCard = currentCard {
            knownCards.append(currentCard)
            remainingCards.removeAll(where: {
                $0.term == currentCard.term && $0.definition == currentCard.definition
            })
            // Above is same as this
//            remainingCards.removeAll(where: { card in
//                card.term == currentCard.term && card.definition == currentCard.definition
//            })
//            if remainingCards.isEmpty {
//                cardView.isHidden = true
//                cardLabel.isHidden = true
//            }
            let startingX = self.cardView.center.x
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 1, delay: 0, animations: {
                self.cardView.center.x -= 2*UIScreen.main.bounds.width
                self.view.layoutIfNeeded()
            }, completion: {_ in
                self.cardView.center.x = 2*UIScreen.main.bounds.width
                self.view.layoutIfNeeded()
                UIView.animate(withDuration: 1, delay: 0, animations: {
                    self.cardView.center.x = startingX
                    self.cardLabel.text = "New Term"
                    self.view.layoutIfNeeded()
                })
            })
        }
    }
}
