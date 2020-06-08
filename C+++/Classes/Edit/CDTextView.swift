//
//  CDTextView.swift
//  Code Editor
//
//  Created by apple on 2020/3/23.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

extension String {
    
    /// Count how many times a character appears in a string.
    /// - Parameter character: The character.
    /// - Returns: How many times the character appears in the string.
    func challenge(_ character: Character) -> Int {
        Array(self).reduce(0, {$1 == character ? $0 + 1 : $0})
    }
    
    /// Get the number of the line which the character at a specific position is in.
    /// - Parameter position: The position.
    /// - Returns: The number of the line which the character at `position` is in.
    func lineNumber(at position: Int) -> Int? {
        
        var lineNumber = 0
        var characterPosition = 0
        for line in self.components(separatedBy: .newlines) {
            lineNumber += 1
            for _ in line {
                characterPosition += 1
                if characterPosition == position {
                    return lineNumber
                }
            }
            characterPosition += 1
            if characterPosition == position {
                return lineNumber
            }
        }
        return 1
        
    }

}



class CDTextView: NSTextView {

    let highlightr = CDHighlightr()
    var gutterDelegate: CDTextViewDelegate!
    var scrollView: CDScrollView!
    var codeTextViewDelegate: CDTextViewDelegate!
    var codeAttributedString: CDAttributedString!
    let parser = CDParser(code: "")
    
    
    
    
    
    /// When the text changes, highlight the text.
    override func didChangeText() {
        
        super.didChangeText()
        
        let a = self.selectedRange
        let code = self.string
        let highlightedCode = highlightr!.highlight(code, as: "C++")
        
        self.textStorage!.setAttributedString(highlightedCode!)
        self.setSelectedRange(a)
        
        DispatchQueue.main.async {
            
            self.codeTextViewDelegate?.didChangeText!(lines: self.textStorage?.paragraphs.count ?? 0, characters: self.textStorage?.characters.count ?? 0)
            self.gutterDelegate?.didChangeText!(lines: (self.textStorage?.paragraphs.count)!, currentLine: self.string.lineNumber(at: self.selectedRange.location)!)
            
        }
        
    }
    
    
    
    /// Inserts the given string into the receiver, replacing the specified content. Overriden to support automatic completion.
    /// - Parameters:
    ///   - string: The text to insert, either an NSString or NSAttributedString instance.
    ///   - replacementRange: The range of content to replace in the receiver’s text storage.
    override func insertText(_ string: Any, replacementRange: NSRange) {
        super.insertText(string, replacementRange: replacementRange)
        
        if config!.autoComplete == false {
            return
        }
        
        var right = ""
        switch string as! String {
            case "(":
                right = ")"
            case "[":
                right = "]"
            case "\"":
                right = "\""
            case "\'":
                right = "\'"
            case "{":
                insertNewline(self)
                let location = self.selectedRange.location
                insertNewline(self)
                deleteBackward(self)
                super.insertText("}", replacementRange: replacementRange)
                self.selectedRange.location = location
                return
            
            default:
                return
        }
        super.insertText(right, replacementRange: replacementRange)
        self.selectedRange.location -= 1
        
    }
    
    
    
    /// When press ENTER, insert tabs.
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
    
    
    override func completions(forPartialWordRange charRange: NSRange, indexOfSelectedItem index: UnsafeMutablePointer<Int>) -> [String]? {
        
        func compare(_ a: String, _ b: String) -> Int {
            var cnt: Int = 0
            if a.count > b.count || a.count == 0 || b.count == 0 {
                return 0
            } else {
                for (index, c) in Array(a).enumerated() {
                    if Array(b)[index] == c {
                        cnt += 1
                    }
                }
            }
            return cnt
        }
        
        var res = [String]()
        let string = (self.string as NSString).substring(with: charRange)
        if string == "" {
            return res
        }
        self.parser.buffer = (self.string as NSString).substring(to: self.selectedRange.location)
        let parserRes = parser.getIdentifiers()
        for i in parserRes {
            if compare(string, i) == string.count {
                res.append(i)
            }
        }
        return res
        
    }
    
    
    override func complete(_ sender: Any?) {
        super.complete(sender)
    }
    
    
    override func insertCompletion(_ word: String, forPartialWordRange charRange: NSRange, movement: Int, isFinal flag: Bool) {
        super.insertCompletion(word, forPartialWordRange: charRange, movement: movement, isFinal: flag)
    }
    
    
    // MARK: - init(coder:)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.textContainer?.size = NSSize(width: CGFloat(Int.max), height: CGFloat(Int.max))
        self.textContainer?.widthTracksTextView = false
        
        if config == nil {
            initDefaultData()
        }
        
        self.highlightr!.setTheme(to: config!.lightThemeName)
        self.highlightr!.theme.setCodeFont(NSFont(name: config!.fontName, size: CGFloat(config!.fontSize))!)
        
    }
    
}
