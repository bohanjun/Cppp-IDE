//
//  SettingsViewController.swift
//  Code Editor
//
//  Created by apple on 2020/4/14.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

@objc protocol SettingsViewDelegate {
    func didSet(_ font: String, _ size: Int, _ dark: String, _ light: String, _ completion: Bool)
}

class SettingsViewController: NSViewController {
    
    @IBOutlet weak var fontname: NSPopUpButton!
    @IBOutlet weak var size: NSComboBox!
    @IBOutlet weak var dark: NSPopUpButton!
    @IBOutlet weak var light: NSPopUpButton!
    @IBOutlet weak var allows: NSButton!
    var delegate: SettingsViewDelegate!
    
    @IBAction func Save(_ sender: NSButton) {
        font = self.fontname.titleOfSelectedItem ?? "Courier"
        fontSize = Int(self.size.stringValue) ?? 15
        themeDark = self.dark.titleOfSelectedItem ?? "Perfect"
        themeLight = self.light.titleOfSelectedItem ?? "Xcode"
        allowsCompletion = self.allows.state == .on
        self.delegate.didSet(font, fontSize, themeDark, themeLight, allowsCompletion)
        
        self.dismiss(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fontname.setTitle(font)
        self.size.stringValue = "\(fontSize)"
        self.dark.setTitle(themeDark)
        self.light.setTitle(themeLight)
    }
    
}
