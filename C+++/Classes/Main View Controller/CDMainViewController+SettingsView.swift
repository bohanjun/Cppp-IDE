//
//  CDMainViewController+SettingsView.swift
//  C+++
//
//  Created by 23786 on 2020/7/3.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

extension CDMainViewController : CDSettingsViewDelegate {
    
    @IBAction func showSettingsView(_ sender: Any) {
        
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        if let ViewController =
            storyboard.instantiateController(
                withIdentifier: NSStoryboard.SceneIdentifier("CDSettingsViewController")) as? CDSettingsViewController {
            ViewController.delegate = self
            self.presentAsSheet(ViewController)
        }
        
    }
    
    func settingsViewControllerDidSet() {
        
        // Theme
        switch isDarkMode {
            case false:
                self.mainTextView.highlightr?.setTheme(to: CDSettings.shared.darkThemeName)
            case true:
                self.mainTextView.highlightr?.setTheme(to: CDSettings.shared.lightThemeName)
        }
        
        // Font
        self.mainTextView.highlightr?.theme.setCodeFont(CDSettings.shared.font)
        self.mainTextView.font = CDSettings.shared.font
        self.mainTextView.didChangeText()
        
        // In case of errors
        changeAppearance(self)
        changeAppearance(self)
        
    }
    
}
