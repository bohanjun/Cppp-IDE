//
//  GutterTextView.swift
//  Code Editor
//
//  Created by apple on 2020/4/21.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

class CDGutterTextView: NSTextView, CDTextViewDelegate {
    
    @objc
    func didChangeText(lines: Int, characters: Int) {
        self.string = ""
        self.isEditable = true
        self.isSelectable = true
        /*var string = ""
        if lines != 0 {
            for i in 1...lines {
                string += "\(i)\n"
            }
            string.removeLast()
        }*/
        // self.textStorage?.setAttributedString(NSAttributedString(string: string, attributes: [.foregroundColor : NSColor.white]))
        self.isEditable = false
        self.isSelectable = false
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        if let savedData = CDSettingsViewController.getSavedData() {
            
            config = savedData
            
        } else {
            
            initDefaultData()
            
        }
        
        self.font = NSFont(name: CDSettingsViewController.getSavedData()?.FontName ?? "Courier", size: CGFloat(CDSettingsViewController.getSavedData()?.FontSize ?? 15))
        
    }
    
}
