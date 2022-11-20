//
//  SummaryVC.swift
//  StudyCard
//
//  Created by Alex Gobert on 10/11/22.
//

import UIKit

class SummaryVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var knownLabel: UILabel!
    @IBOutlet weak var unknownLabel: UILabel!
    @IBOutlet weak var knownCounter: UILabel!
    @IBOutlet weak var unknownCounter: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var retryUnknownButton: UIButton!
    @IBOutlet weak var retryAllButton: UIButton!
    
    let sections: [String] = ["Known Terms", "Unknown Terms"]
    var cards: CardSet!
    var knownCards: [Card]!
    var unknownCards: [Card]!
    var sectionedCards: [[Card]] { [knownCards, unknownCards] }
    
    var delegate: StudyViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        navigationItem.hidesBackButton = true // hide back button
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // set variable height for rows
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        
        // update UILabels
        knownCounter.text = "\(knownCards.count)"
        unknownCounter.text = "\(unknownCards.count)"
        
        // update times studied
        cards.incrementTimesStudied()
        cards.updatePercent(knownCount: knownCards.count)
        
        // theme compliance
        view.backgroundColor = globalBkgdColor
        
        // theme compliance
        let labels: [UILabel] = [
            titleLabel,
            knownLabel,
            unknownLabel,
            knownCounter,
            unknownCounter
        ]
        for label in labels {
            label.font = globalFont
        }
        retryUnknownButton.titleLabel?.font = globalFont
        retryAllButton.titleLabel?.font = globalFont
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numRows: Int
        
        switch section {
        case 0:
            numRows = knownCards.count
        case 1:
            numRows = unknownCards.count
        default:
            numRows = 0
        }
        
        return numRows
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SummaryTableViewCell", for: indexPath) as! SummaryTableViewCell
        let card: Card = sectionedCards[indexPath.section][indexPath.row]
        
        cell.setCard(card)
        cell.setFont(globalFont)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func retryButtonPressed(_ sender: UIButton) {
        guard let senderTitle = sender.titleLabel?.text else {
            return
        }
        
        var newSet: CardSet
        
        if senderTitle.contains("unknown") {
            guard !unknownCards.isEmpty else {
                errorAlert(message: "No Unknown Cards")
                return
            }
            
            newSet = CardSet(name: cards.getName(), cards: unknownCards)
            newSet.parent = cards
        } else {
            newSet = cards
        }
        
        delegate.cardSet = newSet
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
}
