//
//  ThemeManager.swift
//  StudyCard
//
//  Created by Chris Tran on 11/20/22.
//

import Foundation

class ThemeManager {
    static var current: ThemeProtocol = DefaultTheme()
    static let themes = [DefaultTheme(), OceanTheme(), SunshineTheme()] as! [ThemeProtocol]
}
