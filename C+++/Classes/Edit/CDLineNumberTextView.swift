//
//  GutterTextView.swift
//  C+++
//
//  Created by apple on 2020/4/21.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

class CDLineNumberTextView: NSTextView, CDCodeEditorDelegate {
    
    @objc
    func codeEditorDidChangeText(lines: Int, currentLine: Int) {
        
        if #available(OSX 10.13, *) {
            self.textColor = NSColor(named: "LineNumberColor")
        } else {
            self.textColor = NSColor.textColor
        }
        
        self.isEditable = true
        self.isSelectable = true
        var string = ""
        var location = 0
        if lines != 0 {
            for i in 1...lines {
                string += "\(i)\n"
                if i == currentLine {
                    location = string.count - 1
                }
            }
            string.removeLast()
        }
        self.string = string
        self.selectedRange.location = location
        self.isEditable = false
        self.isSelectable = false
        
    }
    
    
    /// Mark a line number with a color.
    /// - Parameters:
    ///   - line: The number of the line to mark.
    ///   - color: The color.
    func markLineNumber(line: Int, color: NSColor) {
        
        if line <= 0 || self.string.count <= 0 {
            return
        }
        
        self.isEditable = true
        self.isSelectable = true
        var string = ""
        var range = NSMakeRange(0, 0)
        if line == 1 && self.string.count >= 1 {
            range = NSMakeRange(0, 1)
        }
        if line > 1 {
            for i in 1..<line {
                string += "\(i)\n"
            }
            range = NSMakeRange(string.count, "\(line)".count)
            string.removeLast()
        }
        self.textStorage?.addAttribute(.foregroundColor, value: color, range: range)
        self.isEditable = false
        self.isSelectable = false
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.font = CDSettings.shared.font
        self.alignment = .right
        
    }
    
}
