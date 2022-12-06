//
//  SetListCell.swift
//  StudyCard
//
//  Created by R Horvath on 11/16/22.
//

import UIKit
import Foundation

class SetListCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var timesStudiedLabel: UILabel!
    @IBOutlet weak var percentKnown: UILabel!
    @IBOutlet weak var percentKnownLabel: UILabel!
    @IBOutlet weak var timesStudied: UILabel!
    
    var font: UIFont!
    var fontColor: UIColor!
//    var backgroundColor: UIColor!
    
    func setName(setName: String) {
        name.text = setName
    }
    
    func setTimes(times: Int) {
        timesStudied.text = String(times)
    }
    
    func setPercent(percent: Float) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.usesSignificantDigits = true
        formatter.maximumSignificantDigits = 3
        
        percentKnown.text = formatter.string(from: percent as NSNumber)
    }
    
    func getName() -> String {
        return name.text ?? ""
    }
    
    func getTimesStudied() -> String {
        return timesStudied.text ?? ""
    }
    
    func getPercentKnown() -> String {
        return percentKnown.text ?? ""
    }
    
}
