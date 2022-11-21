//
//  Themes.swift
//  StudyCard
//
//  Created by Chris Tran on 11/20/22.
//

import UIKit

struct DefaultTheme: ThemeProtocol {
    var fontColor: UIColor = .white
    var backgroundColor: UIColor = .gray
    var lightColor: UIColor = .lightGray
    var secondaryColor: UIColor = UIColor(red: 167/255, green: 199/255, blue: 231/255, alpha: 1.0)
}
struct OceanTheme: ThemeProtocol {
    var fontColor: UIColor = .white
    var backgroundColor: UIColor = UIColor(red: 107/255, green: 111/255, blue: 158/255, alpha: 1.0)
    var lightColor: UIColor = UIColor(red: 141/255, green: 146/255, blue: 215/255, alpha: 0.8)
    var secondaryColor: UIColor = UIColor(red: 141/255, green: 153/255, blue: 174/255, alpha: 1.0)
}
struct SunshineTheme: ThemeProtocol {
    var fontColor: UIColor = .black
    var backgroundColor: UIColor = UIColor(red: 245/255, green: 100/255, blue: 22/255, alpha: 1.0)
    var lightColor: UIColor = UIColor(red: 245/255, green: 157/255, blue: 105/255, alpha: 0.8)
    var secondaryColor: UIColor = UIColor(red: 190/255, green: 26/255, blue: 26/255, alpha: 1.0)
}
