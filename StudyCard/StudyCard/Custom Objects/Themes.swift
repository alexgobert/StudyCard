//
//  Themes.swift
//  StudyCard
//
//  Created by Chris Tran on 11/20/22.
//

import UIKit

//struct DefaultTheme: ThemeProtocol {
//    var fontColor: UIColor = .white
//    var backgroundColor: UIColor = .gray
//    var lightColor: UIColor = .lightGray
//    var secondaryColor: UIColor = UIColor(red: 167/255, green: 199/255, blue: 231/255, alpha: 1.0)
//}
struct DefaultTheme: ThemeProtocol {
    var fontColor: UIColor = UIColor(red: 120/255, green: 250/255, blue: 240/255, alpha: 1)
    var backgroundColor: UIColor = UIColor(red: 11/255, green: 20/255, blue: 31/255, alpha: 1.0)
    var lightColor: UIColor = UIColor(red: 8/255, green: 129/255, blue: 130/255, alpha: 1.0)
    var secondaryColor: UIColor =  UIColor(red: 0/255, green: 90/255, blue: 90/255, alpha: 1.0)
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

// extension that allows storing of colors to user defaults
extension UserDefaults {
    func colorForKey(key: String) -> UIColor? {
      var colorReturnded: UIColor?
      if let colorData = data(forKey: key) {
        do {
          if let color = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(colorData) as? UIColor {
            colorReturnded = color
          }
        } catch {
          print("Error UserDefaults")
        }
      }
      return colorReturnded
    }
    
    func setColor(color: UIColor?, forKey key: String) {
      var colorData: NSData?
      if let color = color {
        do {
          let data = try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false) as NSData?
          colorData = data
        } catch {
          print("Error UserDefaults")
        }
      }
      set(colorData, forKey: key)
    }
  }
