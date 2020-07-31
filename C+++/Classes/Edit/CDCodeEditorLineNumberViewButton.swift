//
//  CDCodeEditorLineNumberViewButton.swift
//  C+++
//
//  Created by 23786 on 2020/7/31.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

class CDCodeEditorLineNumbetViewButton: NSButton {
    
    var backgroundColor: NSColor!
    
    private func drawBackground(color: NSColor) {
        
        self.backgroundColor = color
        self.wantsLayer = true
        self.layer?.backgroundColor = color.cgColor
        self.layer?.setNeedsDisplay()
        
    }
    
    func markAsErrorLine() {
        self.drawBackground(color: .systemRed)
    }
    
    func markAsDebugLine() {
        self.drawBackground(color: .systemBlue)
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        self.wantsLayer = true
        self.layer?.masksToBounds = true
        self.layer?.cornerRadius = frameRect.height / 2 - 4
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
