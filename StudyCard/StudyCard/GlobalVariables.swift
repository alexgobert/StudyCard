//
//  GlobalVariables.swift
//  StudyCard
//
//  Created by Alex Gobert on 11/8/22.
//

import UIKit

var globalFont: UIFont! = UIFont(name: "ArialMT", size: 20)
var globalBkgdColor: UIColor! = UIColor.black
var globalFontColor: UIColor! = UIColor.white


// Use this to find possible font names
func printMyFonts() {
    print("--------- Available Font names ----------")
    for name in UIFont.familyNames {
        print(name)
        print(UIFont.fontNames(forFamilyName: name))
    }
}
