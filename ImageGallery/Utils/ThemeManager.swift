//
//  AppTheme.swift
//  ImageGallery
//
//  Created by Syed Zain ul Abideen on 17/03/2021.
//

import Foundation
import SwiftUI
import Combine

class ThemeManager: ObservableObject {
    static let shared = ThemeManager()
    private init() { }
    @Published public private(set) var currentTheme:Themeable = ThemeValue.spring.value
    
    func selectTheme(_ themeValue:ThemeValue) {
        self.currentTheme = themeValue.value
    }
}

struct SpringTheme:Themeable  {
    var bodyColor: Color = Color.white
    var componentBgColor: Color = Color.gray.opacity(0.4)
    var inputTextColor: Color = Color.black
}

struct SummerTheme:Themeable  {
    var bodyColor: Color = Color.white
    var componentBgColor: Color = Color.yellow.opacity(0.4)
    var inputTextColor: Color = Color.black
}

enum ThemeValue:String {
    case spring
    case summer
    
    var value:Themeable {
        switch self {
        case .spring:
            return SpringTheme()
        case .summer:
            return SummerTheme()
        }
    }
}

protocol Themeable {
    var bodyColor:Color { get }
    var componentBgColor:Color { get }
    var inputTextColor:Color { get }
}
