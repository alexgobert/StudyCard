//
//  SetListCell.swift
//  StudyCard
//
//  Created by A Horvath on 11/16/22.
//

import UIKit

class SetListCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var timesStudied: UILabel!
    @IBOutlet weak var percentKnown: UILabel!
    
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
        percentKnown.text = "\(percent)%"
    }
    
    func getName() -> String {
        return name.text!
    }
    
    func getTimesStudied() -> String {
        return timesStudied.text!
    }
    
    func getPercentKnown() -> String {
        return percentKnown.text!
    }
    
}
