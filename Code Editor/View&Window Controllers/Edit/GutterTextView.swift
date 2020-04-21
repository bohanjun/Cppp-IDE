//
//  GutterTextView.swift
//  Code Editor
//
//  Created by apple on 2020/4/21.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

class GutterTextView: NSTextView, CDTextViewDelegate {
    
    @objc
    func didChangeText(lines: Int, characters: Int) {
        self.string = ""
        self.isEditable = true
        self.isSelectable = true
        if lines != 0 {
            for i in 1...lines {
                self.insertText("\(i)\n", replacementRange: self.selectedRange)
            }
            self.string.removeLast()
        }
        self.isEditable = false
        self.isSelectable = false
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        if let savedData = SettingsViewController.getSavedData() {
            
            config = savedData
            
        } else {
            
            initDefaultData()
            
        }
        
        self.font = NSFont(name: SettingsViewController.getSavedData()?.FontName ?? "Courier", size: CGFloat(SettingsViewController.getSavedData()?.FontSize ?? 15))
        
    }
    
}
