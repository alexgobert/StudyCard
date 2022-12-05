//
//  StudyViewController.swift
//  StudyCard
//
//  Created by Sam Song on 10/19/22.
//


import UIKit
import AVKit

class StudyViewController: UIViewController {
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var knownLabel: UILabel!
    @IBOutlet weak var unknownLabel: UILabel!
    @IBOutlet weak var swipeLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var cardLabel: UILabel!
    
    let animationDuration: TimeInterval = 0.5 // seconds
    
    var cardSet: CardSet!
    var itemFirst: String! // term, def, or mixed
    var currentCard: Card!
    var isShowingTerm = true
    var isAnimating = false
    var knownCards: [Card]!
    var unknownCards: [Card]!
    var remainingCards: [Card]!
    
    var audioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapCard))
        cardView.addGestureRecognizer(tapGestureRecognizer)
        catchNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // initialize card arrays
        remainingCards = cardSet.cards
        knownCards = []
        unknownCards = []
        
        // initialize progress
        progressBar.setProgress(0, animated: false)
        
        // update UI
        changeCard()
        
        // theme compliance
        applyTheme()
    }
    
    func studyDone() {
        performSegue(withIdentifier: "SummarySegue", sender: nil)
    }
    
    func changeCard() {
        guard !remainingCards.isEmpty else {
            studyDone()
            return
        }
        
        currentCard = remainingCards.first
        
        // determine whether term or def should be displayed
        switch itemFirst {
        case "Term":
            isShowingTerm = true
        case "Definition":
            isShowingTerm = false
        default: // mixed by default
            isShowingTerm = Bool.random()
        }
        
        // change card label
        cardLabel.text = isShowingTerm ? currentCard.getTerm() : currentCard.getDef()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SummarySegue", let dest = segue.destination as? SummaryVC {
            dest.delegate = self
            dest.knownCards = knownCards
            dest.unknownCards = unknownCards
            dest.cards = cardSet
        }
    }
    
    func setCards(_ cardSet: CardSet) {
        self.cardSet = cardSet
    }
    
    func playSound(named resource: String) {
        guard let url = Bundle.main.url(forResource: resource, withExtension: "mp3") else { return }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @objc func didTapCard() {
        // only allow one animation at a time
        guard !isAnimating else {
            return
        }
        
        // begin animation
        isAnimating = true
        
        cardLabel.text = isShowingTerm ? currentCard.getDef() : currentCard.getTerm()
        UIView.transition(
            with: cardView,
            duration: animationDuration,
            options: isShowingTerm ? .transitionFlipFromRight : .transitionFlipFromLeft,
            animations: nil
        )
        if userDefaults.bool(forKey: MUTE_KEY) == false {
            playSound(named: "CardFlip")
        }
    
        // post conditions
        isShowingTerm.toggle()
        isAnimating = false
    }
    
    // Right swipe Gesture
    @IBAction func rightGesture(_ sender: UISwipeGestureRecognizer) {
        // only allow one animation at a time
        guard !isAnimating else {
            return
        }
        
        isAnimating = true
        
        // process card
        unknownCards.append(currentCard)
        remainingCards.removeAll(where: { $0 == currentCard })
        
        // animate card motion
        animateCard(outBoundDirection: "Right")
        if userDefaults.bool(forKey: MUTE_KEY) == false {
            playSound(named: "CardSwoosh")
        }
    }
    
    // Left swipe Gesture
    @IBAction func leftGesture(_ sender: UISwipeGestureRecognizer) {
        // only allow one animation at a time
        guard !isAnimating else {
            return
        }
        
        isAnimating = true
        
        // process card
        knownCards.append(currentCard)
        remainingCards.removeAll(where: { $0 == currentCard })
        
        // animate card motion
        animateCard(outBoundDirection: "Left")
        if userDefaults.bool(forKey: MUTE_KEY) == false {
            playSound(named: "CardSwoosh")
        }
    }
    
    func animateCard(outBoundDirection: String) {
        // unit scalar that determines x direction of motion
        // -1 if left, +1 else (right)
        let sign: CGFloat = outBoundDirection == "Left" ? -1 : 1
        
        // animate progress bar async (simultaneous with card animation)
        DispatchQueue.global(qos: .utility).async {
            let progress = 1.0 - Float(self.remainingCards.count) / Float(self.cardSet.count)
            
            DispatchQueue.main.async { // update UI
                self.progressBar.setProgress(progress, animated: true)
            }
        }
        
        // animate card according to sign
        let startingX: CGFloat = cardView.center.x
        let offscreenX: CGFloat = 2 * UIScreen.main.bounds.width
        view.layoutIfNeeded()
        UIView.animate(
            withDuration: animationDuration,
            delay: 0,
            animations: {
                // slide off screen left or right, depending on sign
                self.cardView.center.x += sign * offscreenX
                self.view.layoutIfNeeded()
            },
            completion: { _ in
                // update current card
                self.changeCard()
                
                // slide in from other side of screen, depending on sign
                self.cardView.center.x = -sign * offscreenX
                self.view.layoutIfNeeded()
                UIView.animate(
                    withDuration: self.animationDuration,
                    delay: 0,
                    animations: {
                        self.cardView.center.x = startingX
                        self.view.layoutIfNeeded()
                    }
                )
            }
        )
        
        isAnimating = false
    }
    
    func catchNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTheme), name: NSNotification.Name("ThemeUpdate"), object: nil)
    }
    
    @objc func reloadTheme() {
        applyTheme()
    }
    
    func applyTheme() {
        self.view.backgroundColor = globalBkgdColor
        progressBar.progressTintColor = globalSecondaryColor
        let labels: [UILabel] = [
            knownLabel,
            unknownLabel,
            swipeLabel
        ]
        for label in labels {
            label.textColor = globalFontColor
            label.font = globalTextFont
        }
    }
    
}
