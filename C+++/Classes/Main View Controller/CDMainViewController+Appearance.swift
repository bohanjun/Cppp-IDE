//
//  CDMainViewController+Appearance.swift
//  C+++
//
//  Created by 23786 on 2020/7/3.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

extension CDMainViewController {
    
    func convertToLightMode() {
        
        // Change the text view's highlight theme to Light Mode.
        self.mainTextView.highlightr?.setTheme(to: CDSettings.shared.lightThemeName)
        
    }
    
    func convertToDarkMode() {
        
        // Change the text view's highlight theme to Dark Mode.
        self.mainTextView.highlightr?.setTheme(to: CDSettings.shared.darkThemeName)
        
    }
    
    /// Change the appearance of the current window.
    func changeAppearance(newAppearance: NSAppearance.Name) {
        
        // print("newAppearance.name = \(newAppearance.name)")
        
        if #available(OSX 10.14, *) {
        
            switch newAppearance {
                
                case .darkAqua, .vibrantDark, .accessibilityHighContrastDarkAqua, .accessibilityHighContrastVibrantDark:
                    self.convertToDarkMode()
                    
                case .vibrantLight, .aqua, .accessibilityHighContrastVibrantLight, .accessibilityHighContrastAqua:
                    self.convertToLightMode()
                    
                default:
                    return
                    
            }
            
            // Change the font of the text view.
            self.mainTextView.didChangeText()
            self.mainTextView.highlightr?.theme.setCodeFont(CDSettings.shared.font)
            self.mainTextView.font = CDSettings.shared.font
            
        } else {
            
            if self.view.window != nil {
                showAlert("Warning", "Your Mac does not support Dark Mode. Dark Mode requires macOS 10.14 Mojave or later. You should update your Mac.")
            }
            return
            
        }
        
    }
    
}
