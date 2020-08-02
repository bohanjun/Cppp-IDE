//
//  CDConsoleView.swift
//  C+++
//
//  Created by 23786 on 2020/8/1.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

class CDConsoleView: NSView {
    
    @IBOutlet weak var titleLabel: NSTextField!
    @IBOutlet weak var textView: NSTextView!
    @IBOutlet weak var sendInputTextField: NSTextField!
    @IBOutlet weak var sendInputButton: NSButton!
    
    @IBAction func sendInput(_ sender: Any?) {
        
        (self.window?.windowController?.document as! CDCodeDocument).sendInputToDebugger(message: self.sendInputTextField.stringValue)
        
    }
    
}
