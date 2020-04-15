//
//  CDTextView.swift
//  Code Editor
//
//  Created by apple on 2020/3/23.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

let completion = [
    "(" : ")",
    "[" : "]",
    "\"" : "\" ",
    "\'" : "\' "
]

extension String {
    
    func challenge(_ input: Character) -> Int {
        var letterCount = 0
        for letter in Array(self) {
            if letter == input {
                letterCount += 1
            }
        }
        return letterCount
    }

}

class CDTextView: NSTextView, SettingsViewDelegate {
    
    // MARK: - SettingsViewDelegate
    
    func didSet(_ font: String, _ size: Int, _ dark: String, _ light: String, _ completion: Bool) {
        
    }
    
    

    let highlightr = Highlightr()
    
    
    // MARK: - Override Functions
    
    /// When the text changes, highlight the text.
    override func didChangeText() {
        
        super.didChangeText()
        
        let a = self.selectedRange.location
        
        let code = self.string
        let highlightedCode = highlightr!.highlight(code, as: "C++")
        self.textStorage!.setAttributedString(highlightedCode!)
        
        self.selectedRange.location = a
        
    }
    
    /// When input "(", "[", etc, insert "]", ")", etc.
    override func shouldChangeText(in affectedCharRange: NSRange, replacementString: String?) -> Bool {
        
        let superResult = super.shouldChangeText(in: affectedCharRange, replacementString: replacementString)
        
        if let left = replacementString {
            
            if allowsCompletion == false {
                return superResult
            }
            
            // When Input "{", insert "}".
            if left == "{" {
                self.insertNewline(self)
                self.insertText("\t", replacementRange: self.selectedRange)
                let desRange = self.selectedRange
                self.insertNewline(self)
                self.insertText("}", replacementRange: self.selectedRange)
                self.selectedRange = desRange
                
                return superResult
            }
            
            
            // When input ")", "]", check if there is already a same symbol on the right.
            if left == ")" {
                let range = self.selectedRange.location
                if self.string.count <= range {
                    return true
                }
                let string = NSString(string: self.string).substring(with: NSMakeRange(range, 1))
                if string == ")" {
                    self.deleteForward(self)
                }
                return superResult
            }
            
            if left == "]" {
                let range = self.selectedRange.location
                if self.string.count <= range {
                    return superResult
                }
                let string = NSString(string: self.string).substring(with: NSMakeRange(range, 1))
                if string == "[" {
                    self.deleteForward(self)
                }
                return superResult
            }
            
            
            // When input "(", "[", etc, insert "]", ")", etc.
            if let right = completion[left] {
                
                let rangeLocation = self.selectedRange.location
                self.insertText(right, replacementRange: self.selectedRange)
                self.selectedRange.location = rangeLocation
                
                self.didChangeText()
                
            }
            
        }
        
        return superResult
    }
    
    
    /// When press ENTER, analyze the code and insert tabs.
    override func insertNewline(_ sender: Any?) {
        super.insertNewline(sender)
        let nsstring = NSString(string: self.string)
        let string = nsstring.substring(to: self.selectedRange.location)
        let l = string.challenge("{")
        let r = string.challenge("}")
        let c = l - r
        if c > 0 {
            for _ in 1...c {
                self.insertText("\t", replacementRange: self.selectedRange)
            }
        }
    }
    
    
    // MARK: - init(coder:)
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        self.highlightr!.setTheme(to: themeLight)
        self.allowsUndo = true
        
    }
    
}
