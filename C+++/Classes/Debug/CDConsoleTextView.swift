//
//  CDConsoleTextView.swift
//  C+++
//
//  Created by 23786 on 2020/8/2.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

protocol CDConsoleTextViewDelegate: NSTextViewDelegate {
    
    func consoleTextViewWillInsertNewLine(_ consoleTextView: CDConsoleTextView, lastLineText: String)
    
}

class CDConsoleTextView: NSTextView {
    
    var isInputtingInLastLine: Bool {
        let array = self.string.components(separatedBy: "\n")
        return self.selectedRange.location >= self.string.count - array.last!.count
    }
    
    override func insertText(_ string: Any, replacementRange: NSRange) {
        if !isInputtingInLastLine {
            return
        }
        if (string as! String).contains("\n") {
            for i in (string as! String).components(separatedBy: "\n") {
                super.insertText(i, replacementRange: self.selectedRange)
                self.insertNewline(nil)
            }
            return
        } else {
            super.insertText(string, replacementRange: replacementRange)
        }
    }
    
    override func paste(_ sender: Any?) {
        self.insertText(NSPasteboard.general.string(forType: .string) ?? "", replacementRange: self.selectedRange)
    }
    
    override func deleteBackward(_ sender: Any?) {
        if self.selectedRange.length == 0 && self.selectedRange.location != 0 {
            let range = NSMakeRange(self.selectedRange.location - 1, 1)
            let string = self.string.nsString.substring(with: range)
            if string.contains("\n") || !isInputtingInLastLine {
                return
            } else {
                super.deleteBackward(sender)
            }
        }
    }
    
    override func insertNewline(_ sender: Any?) {
        (self.delegate as! CDConsoleTextViewDelegate).consoleTextViewWillInsertNewLine(self, lastLineText: self.string.components(separatedBy: "\n").last!)
        self.deleteToBeginningOfLine(self)
    }
    
}
