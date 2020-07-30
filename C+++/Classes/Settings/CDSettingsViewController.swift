//
//  SettingsViewController.swift
//  C+++
//
//  Created by apple on 2020/4/14.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

public func initDefaultData() {

    do {
        try FileManager().createDirectory(at: FileManager().urls(for: .libraryDirectory, in: .userDomainMask).first!.appendingPathComponent("C+++"), withIntermediateDirectories: true, attributes: nil)
    } catch {
        return
    }
    
    // Create the default data.
    CDSettings.shared = CDSettings("Courier", 15, "Xcode", "Agate", true, true, true, true)!
    CDCompileSettings.shared = CDCompileSettings("g++", "")!
    
}

@objc protocol CDSettingsViewDelegate {
    func settingsViewControllerDidSet()
}

class CDSettingsViewController: NSViewController {
    
    
    @IBOutlet weak var fontname: NSPopUpButton!
    @IBOutlet weak var size: NSComboBox!
    @IBOutlet weak var dark: NSPopUpButton!
    @IBOutlet weak var light: NSPopUpButton!
    @IBOutlet weak var allowsCompletion: NSButton!
    @IBOutlet weak var showsCompletionList: NSButton!
    @IBOutlet weak var checksUpdate: NSButton!
    @IBOutlet weak var liveIssues: NSButton!
    
    @IBOutlet weak var compiler: NSComboBox!
    @IBOutlet weak var arguments: NSTextField!
    
    
    var delegate: CDSettingsViewDelegate!
    
    
    @IBAction func save(_ sender: NSButton) {
        
        let settings = CDSettings.shared!
        settings.fontName = self.fontname.titleOfSelectedItem ?? "Courier"
        settings.fontSize = Int(self.size.stringValue) ?? 15
        settings.darkThemeName = self.dark.titleOfSelectedItem ?? "Agate"
        settings.lightThemeName = self.light.titleOfSelectedItem ?? "Xcode"
        settings.autoComplete = self.allowsCompletion.state == .on
        settings.codeCompletion = self.showsCompletionList.state == .on
        settings.checkUpdateAfterLaunching = self.checksUpdate.state == .on
        settings.showLiveIssues = self.checksUpdate.state == .on
        
        let compileSettings = CDCompileSettings.shared!
        compileSettings.compiler = self.compiler.stringValue
        compileSettings.arguments = self.arguments.stringValue
        
        CDSettings.shared = settings
        CDCompileSettings.shared = compileSettings
        
        self.delegate?.settingsViewControllerDidSet()
        
        self.dismiss(self)
        
    }
    
    
    
    @IBAction func chooseAnotherFont(_ sender: Any?) {
        
        NSFontPanel.shared.setPanelFont(CDSettings.shared.font, isMultiple: false)
        NSFontManager.shared.target = self
        NSFontManager.shared.action = #selector(changeFont(_:))
        NSFontManager.shared.orderFrontFontPanel(self)
        
    }
    
    @objc func changeFont(_ sender: Any?) {
        
        let font = CDSettings.shared.font
        let convertedFont = NSFontPanel.shared.convert(font)
        self.fontname.setTitle(convertedFont.fontName )
        self.size.stringValue = "\(Int(convertedFont.pointSize))"
        
    }
    
    @IBAction func defaultSettings(_ sender: Any?) {
        
        self.sendUserNotification(title: "Recover to default settings", subtitle: "C+++ will restart.")
        CDFileCompiler.shell("rm -rf ~/Library/C+++/Settings")
        CDFileCompiler.shell("rm -rf ~/Library/C+++/CompileSettings")
        let process = Process()
        process.launchPath = "/bin/bash"
        process.arguments = ["-c", "sleep 1.0; open \(Bundle.main.bundlePath)"]
        process.launch()
        print("launched")
        NSApplication.shared.stop(sender)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedData = CDSettings.shared {
            
            self.fontname.setTitle(savedData.fontName)
            self.size.stringValue = "\(savedData.fontSize ?? 15)"
            self.dark.setTitle(savedData.darkThemeName)
            self.light.setTitle(savedData.lightThemeName)
            
            if savedData.autoComplete {
                self.allowsCompletion.state = .on
            } else {
                self.allowsCompletion.state = .off
            }
            
            if savedData.codeCompletion {
                self.showsCompletionList.state = .on
            } else {
                self.showsCompletionList.state = .off
            }
            
            if savedData.checkUpdateAfterLaunching {
                self.checksUpdate.state = .on
            } else {
                self.checksUpdate.state = .off
            }
            
            if savedData.checkUpdateAfterLaunching {
                self.checksUpdate.state = .on
            } else {
                self.checksUpdate.state = .off
            }
            
        }
        
        if let savedCompileSettingsData = CDCompileSettings.shared {
            
            self.compiler.stringValue = savedCompileSettingsData.compiler
            self.arguments.stringValue = savedCompileSettingsData.arguments
            
        }
        
    }
    
}
