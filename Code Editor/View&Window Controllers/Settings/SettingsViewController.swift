//
//  SettingsViewController.swift
//  Code Editor
//
//  Created by apple on 2020/4/14.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa


var config: Settings!

public func initDefaultData() {
    
    config = Settings("Courier", 15, "Perfect", "Xcode", false)
    NSKeyedArchiver.archiveRootObject(config!, toFile: Settings.ArchiveURL.path)
    
}

@objc protocol SettingsViewDelegate {
    func didSet()
}

class SettingsViewController: NSViewController {
    
    
    
    @IBOutlet weak var fontname: NSPopUpButton!
    @IBOutlet weak var size: NSComboBox!
    @IBOutlet weak var dark: NSPopUpButton!
    @IBOutlet weak var light: NSPopUpButton!
    @IBOutlet weak var allows: NSButton!
    var delegate: SettingsViewDelegate!
    
    
    @IBAction func Save(_ sender: NSButton) {
        
        config.FontName = self.fontname.titleOfSelectedItem ?? "Courier"
        config.FontSize = Int(self.size.stringValue) ?? 15
        config.DarkThemeName = self.dark.titleOfSelectedItem ?? "Perfect"
        config.LightThemeName = self.light.titleOfSelectedItem ?? "Xcode"
        config.AutoComplete = self.allows.state == .on
        
        NSKeyedArchiver.archiveRootObject(config!, toFile: Settings.ArchiveURL.path)
        
        self.dismiss(self)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedData = getSavedData() {
            
            self.fontname.setTitle(savedData.FontName)
            self.size.stringValue = "\(savedData.FontSize ?? 15)"
            self.dark.setTitle(savedData.DarkThemeName)
            self.light.setTitle(savedData.LightThemeName)
            
            if savedData.AutoComplete {
                self.allows.state = .on
            } else {
                self.allows.state = .off
            }
            
        } else {
            
            createDefaultData()
            
        }
        
    }
    
    private func getSavedData() -> Settings? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Settings.ArchiveURL.path) as? Settings
    }
    
    private func createDefaultData() {

        self.fontname.setTitle("Courier")
        self.size.stringValue = "15"
        self.dark.setTitle("Perfect")
        self.light.setTitle("Xcode")
        self.allows.state = .on
        
        initDefaultData()
        
    }
    
}
