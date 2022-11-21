//
//  GlobalVariables.swift
//  StudyCard
//
//  Created by Alex Gobert on 11/8/22.
//

import UIKit

var globalTextFont: UIFont! = UIFont(name: userDefaults.string(forKey: FONT_KEY) ?? "TimesNewRomanPSMT", size: 14)
var globalButtonFont: UIFont! = UIFont(name: userDefaults.string(forKey: FONT_KEY) ?? "TimesNewRomanPSMT", size: 15)
var globalBackButtonFont: UIFont! = UIFont(name: userDefaults.string(forKey: FONT_KEY) ?? "TimesNewRomanPSMT", size: 20)
var globalTitleFont: UIFont! = UIFont(name: userDefaults.string(forKey: FONT_KEY) ?? "TimesNewRomanPSMT", size: 34)
var globalBkgdColor: UIColor! = .white
var globalFontColor: UIColor! = .black


// Use this to find possible font names
func printMyFonts() {
    print("--------- Available Font names ----------")
    for name in UIFont.familyNames {
        print(name)
        print(UIFont.fontNames(forFamilyName: name))
    }
}
