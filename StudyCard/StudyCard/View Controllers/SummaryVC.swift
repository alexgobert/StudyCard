//
//  SummaryVC.swift
//  StudyCard
//
//  Created by Alex Gobert on 10/11/22.
//

import UIKit
import CoreData

class SummaryVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var knownLabel: UILabel!
    @IBOutlet weak var unknownLabel: UILabel!
    @IBOutlet weak var knownCounter: UILabel!
    @IBOutlet weak var unknownCounter: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var retryUnknownButton: UIButton!
    @IBOutlet weak var retryAllButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    let sections: [String] = ["Known Terms", "Unknown Terms"]
    var cards: CardSet!
    var knownCards: [Card]!
    var unknownCards: [Card]!
    var sectionedCards: [[Card]] { [knownCards, unknownCards] }
    var setIndex: Int!
    var context: NSManagedObjectContext!
    var knownCardCount: Int!
    var allCards: CardSet!
    
    var delegate: StudyViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set variable height for rows
        // tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationItem.hidesBackButton = true // hide back button
        catchNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // update UILabels
        knownCounter.text = "\(knownCards.count)"
        unknownCounter.text = "\(unknownCards.count)"
        
        // update times studied
        allCards.incrementTimesStudied()
        allCards.updatePercent(knownCount: knownCardCount, totalCount: allCards.count)
        
        allCards.updateStats(index: setIndex, newCount: allCards.getTimesStudied(), newPercent: allCards.getPercentKnown(), setContext: context)
        
        // theme compliance
        applyTheme()
        
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
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        view.tintColor = globalBkgdColor
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = globalFontColor
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SummaryTableViewCell", for: indexPath) as! SummaryTableViewCell
        let card: Card = sectionedCards[indexPath.section][indexPath.row]
        
        cell.setCard(card)
        cell.setColor(backgroundColor: globalBkgdColor, fontColor: globalFontColor)
        cell.setFont(globalTextFont)
        
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
            
            delegate.knownCount = knownCardCount
            
        } else {
            newSet = cards
            delegate.knownCount = 0
        }
        
        delegate.cardSet = newSet
        
        navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func catchNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTheme), name: NSNotification.Name("ThemeUpdate"), object: nil)
    }
    
    @objc func reloadTheme() {
        applyTheme()
    }
    
    func applyTheme() {
        self.navigationController?.navigationBar.tintColor = globalFontColor
        self.view.backgroundColor = globalBkgdColor
        tableView.backgroundColor = globalBkgdColor
        
        doneButton.tintColor = globalSecondaryColor
        retryUnknownButton.tintColor = globalSecondaryColor
        retryAllButton.tintColor = globalSecondaryColor
        
        let labels: [UILabel] = [
            titleLabel,
            knownLabel,
            unknownLabel,
            knownCounter,
            unknownCounter
        ]
        for label in labels {
            label.textColor = globalFontColor
            label.font = globalTextFont
        }
        
        retryUnknownButton.titleLabel?.font = globalButtonFont
        retryAllButton.titleLabel?.font = globalButtonFont
    }
}
