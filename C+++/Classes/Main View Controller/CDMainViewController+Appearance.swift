//
//  CDMainViewController+Appearance.swift
//  C+++
//
//  Created by 23786 on 2020/7/3.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

extension CDMainViewController {
    
    /// Change the appearance of the current window.
    @IBAction func changeAppearance(_ sender: Any) {
        
        if #available(OSX 10.14, *) {
        } else {
            if let _ = self.view.window {
                showAlert("Warning", "Your Mac does not support Dark Mode. Dark Mode requires macOS 10.14 Mojave or later. You should update your Mac.")
            }
            return
        }
        
        // judge the current appearance.
        switch isDarkMode {
            
            // Dark Mode
            case true:
                
                // Change the text view's highlight theme to Dark Mode.
                self.mainTextView.highlightr?.setTheme(to: CDSettings.shared.darkThemeName)
                
                // Chage the window's appearance to Dark Mode.
                if #available(OSX 10.14, *) {
                    self.view.window?.appearance = darkAqua
                    self.view.appearance = darkAqua
                    for view in self.view.subviews {
                        view.appearance = darkAqua
                    }
                    isDarkMode = false
                }
            
            // Light Mode
            case false:
                
                // Change the text view's highlight theme to Light Mode.
                self.mainTextView.highlightr?.setTheme(to: CDSettings.shared.lightThemeName)
                
                // Chage the window's appearance to Light Mode.
                if #available(OSX 10.14, *) {
                    self.view.window?.appearance = aqua
                    self.view.appearance = aqua
                    for view in self.view.subviews {
                        view.appearance = aqua
                    }
                    isDarkMode = true
                }
            
        }
        
        // Change the font of the text view.
        self.mainTextView.didChangeText()
        self.mainTextView.highlightr?.theme.setCodeFont(CDSettings.shared.font)
        self.mainTextView.font = CDSettings.shared.font
        
    }
    
}
