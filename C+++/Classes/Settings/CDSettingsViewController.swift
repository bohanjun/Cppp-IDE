//
//  SettingsViewController.swift
//  Code Editor
//
//  Created by apple on 2020/4/14.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa


var config: Settings? {
    get {
        return CDSettingsViewController.getSavedData()
    }
    set {
        NSKeyedArchiver.archiveRootObject(newValue!, toFile: Settings.archiveURL.path)
    }
}

var compileConfig: CompileSettings? {
    get {
        return CDSettingsViewController.getSavedCompileSettings()
    }
    set {
        NSKeyedArchiver.archiveRootObject(newValue!, toFile: CompileSettings.ArchiveURL.path)
    }
}

public func initDefaultData() {

    do {
        try FileManager().createDirectory(at: FileManager().urls(for: .libraryDirectory, in: .userDomainMask).first!.appendingPathComponent("C+++"), withIntermediateDirectories: true, attributes: nil)
    } catch {
        return
    }
    // Create the default data.
    config = Settings("Courier", 15, "Xcode", "Agate", true)!
    compileConfig = CompileSettings("g++", "")!
    
}

@objc protocol CDSettingsViewDelegate {
    func didSet()
}

class CDSettingsViewController: NSViewController {
    
    
    @IBOutlet weak var fontname: NSPopUpButton!
    @IBOutlet weak var size: NSComboBox!
    @IBOutlet weak var dark: NSPopUpButton!
    @IBOutlet weak var light: NSPopUpButton!
    @IBOutlet weak var allows: NSButton!
    
    @IBOutlet weak var compiler: NSComboBox!
    @IBOutlet weak var arguments: NSTextField!
    
    
    var delegate: CDSettingsViewDelegate!
    
    
    @IBAction func Save(_ sender: NSButton) {
        
        let settings = config!
        settings.fontName = self.fontname.titleOfSelectedItem ?? "Courier"
        settings.fontSize = Int(self.size.stringValue) ?? 15
        settings.darkThemeName = self.dark.titleOfSelectedItem ?? "Agate"
        settings.lightThemeName = self.light.titleOfSelectedItem ?? "Xcode"
        settings.autoComplete = self.allows.state == .on
        
        let compileSettings = compileConfig!
        compileSettings.compiler = self.compiler.stringValue
        compileSettings.arguments = self.arguments.stringValue
        
        config = settings
        compileConfig = compileSettings
        
        self.delegate.didSet()
        
        self.dismiss(self)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedData = CDSettingsViewController.getSavedData() {
            
            self.fontname.setTitle(savedData.fontName)
            self.size.stringValue = "\(savedData.fontSize ?? 15)"
            self.dark.setTitle(savedData.darkThemeName)
            self.light.setTitle(savedData.lightThemeName)
            
            if savedData.autoComplete {
                self.allows.state = .on
            } else {
                self.allows.state = .off
            }
            
        }
        
        if let savedData2 = CDSettingsViewController.getSavedCompileSettings() {
            
            self.compiler.stringValue = savedData2.compiler
            self.arguments.stringValue = savedData2.arguments
            
        }
        
    }
    
    public static func getSavedData() -> Settings? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Settings.archiveURL.path) as? Settings
    }
    
    public static func getSavedCompileSettings() -> CompileSettings? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: CompileSettings.ArchiveURL.path) as? CompileSettings
    }
    
}
