//
//  CTView.swift
//  Code Editor
//
//  Created by apple on 2020/3/24.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

class CTView: NSView {
    
    var titleLabel: NSTextField!
    var codeLabel: NSTextView!
    var button: NSButton!
    let highlightr = Highlightr()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setUp()
        
    }
    
    func reinit(name: String, code: String) {
        self.titleLabel.stringValue = name
        self.codeLabel.string = code
        let code = self.codeLabel.string
        
        if #available(OSX 10.14, *) {
            self.highlightr?.setTheme(to: SettingsViewController.getSavedData()!.DarkThemeName)
        } else {
            self.highlightr?.setTheme(to: SettingsViewController.getSavedData()!.LightThemeName)
        }
        self.highlightr?.theme.setCodeFont(NSFont(name: SettingsViewController.getSavedData()!.FontName, size: 14.0)!)
        
        let highlightedCode = highlightr!.highlight(code, as: "C++")
        self.codeLabel.textStorage?.setAttributedString(highlightedCode!)
    }
    
    func setUp() {
        
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor(srgbRed: 120.0, green: 20.0, blue: 20.0, alpha: 0.0).cgColor
        
        self.frame = CGRect(x: 190, y: 0, width: 260, height: 300)
        self.bounds = CGRect(x: 190, y: 0, width: 260, height: 300)
        self.titleLabel = NSTextField(frame: CGRect(x: 200, y: 30, width: 240, height: 40))
        self.titleLabel.font = NSFont.boldSystemFont(ofSize: 22.0)
        self.titleLabel.isBordered = false
        self.titleLabel.isEditable = false
        self.titleLabel.textColor = .white
        self.titleLabel.backgroundColor = NSColor(srgbRed: 20.0, green: 20.0, blue: 20.0, alpha: 0.0)
        self.titleLabel.drawsBackground = false
        self.addSubview(titleLabel)
        
        let scrollView = NSScrollView(frame: CGRect(x: 200, y: 90, width: 240, height: 200))
        scrollView.hasVerticalScroller = true
        self.addSubview(scrollView)
        
        
        self.codeLabel = NSTextView(frame: CGRect(x: 200, y: 90, width: 225, height: 200))
        self.codeLabel.backgroundColor = .black
        self.highlightr?.theme.setCodeFont(NSFont(name: SettingsViewController.getSavedData()!.FontName, size: 14.0)!)
        self.codeLabel.textColor = .white
        self.codeLabel.isEditable = false
        if #available(OSX 10.14, *) {
            self.highlightr?.setTheme(to: SettingsViewController.getSavedData()!.DarkThemeName)
        } else {
            self.highlightr?.setTheme(to: SettingsViewController.getSavedData()!.LightThemeName)
        }
        scrollView.documentView = codeLabel
        
        self.button = NSButton(frame: CGRect(x: 200, y: 15, width: 135, height: 20))
        self.button.title = "Copy to Pasteboard"
        self.button.bezelStyle = .texturedRounded
        self.button.target = self
        self.button.action = #selector(copyToPasteboard)
        self.addSubview(button)
        
    }
    
    @objc func copyToPasteboard() {
        let code = self.codeLabel.string
        
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(code, forType: .string)
        
    }
    
}
