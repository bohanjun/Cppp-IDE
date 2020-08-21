//
//  CDProjectSettingsView.swift
//  C+++
//
//  Created by 23786 on 2020/8/21.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

protocol CDProjectSettingsViewDelegate {
    
    func projectSettingsDidChangeVersion(to: String)
    
    func projectSettingsDidChangeCompileCommandSettings(useDefault: Bool)
    
}

class CDProjectSettingsView: NSView, NSTextFieldDelegate {
    
    var delegate: CDProjectSettingsViewDelegate?
    
    @IBOutlet weak var versionTextField: NSTextField!
    @IBOutlet weak var button: NSButton!
    
    @IBAction func buttonClicked(_ sender: NSButton) {
        
        self.delegate?.projectSettingsDidChangeCompileCommandSettings(useDefault: sender.state == .on)
        
    }
    
    func controlTextDidChange(_ obj: Notification) {
        
        self.delegate?.projectSettingsDidChangeVersion(to: self.versionTextField.stringValue)
        
    }
    
}
