//
//  CDCodeEditorLineNumberViewButton.swift
//  C+++
//
//  Created by 23786 on 2020/7/31.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

class CDCodeEditorLineNumberViewButton: NSButton {
    
    var backgroundColor: NSColor!
    var isBreakpoint: Bool = false
    
    private func drawBackground(color: NSColor) {
        
        self.backgroundColor = color
        self.wantsLayer = true
        self.layer?.backgroundColor = color.cgColor
        self.layer?.setNeedsDisplay()
        
    }
    
    func markAsErrorLine() {
        self.drawBackground(color: .systemRed)
    }
    
    func markAsBreakpointLine() {
        let superview = self.superview! as! CDCodeEditorLineNumberView
        if self.isBreakpoint == true {
            self.isBreakpoint = false
            superview.debugLines.remove(at: superview.debugLines.firstIndex(of: self.title.nsString.integerValue) ?? 0)
            superview.draw(superview.codeEditor.lineRects)
            return
        }
        self.isBreakpoint = true
        self.drawBackground(color: .systemBlue)
        if self.superview != nil {
            superview.debugLines.append(self.title.nsString.integerValue)
        }
    }
    
    func markAsWarningLine() {
        self.drawBackground(color: .systemYellow)
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
