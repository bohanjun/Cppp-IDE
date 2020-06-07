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
    "[" : "]"
]


extension String {
    
    func challenge(_ character: Character) -> Int {
        Array(self).reduce(0, {$1 == character ? $0 + 1 : $0})
    }

}

class CDTextView: NSTextView {

    let highlightr = CDHighlightr()
    var gutterDelegate: CDTextViewDelegate!
    var scrollView: CDScrollView!
    var codeTextViewDelegate: CDTextViewDelegate!
    var codeAttributedString: CDAttributedString!
    let parser = CDParser(code: "")
    
    private var completeWhenChangingText = true
    
    // MARK: - Override Functions
    
    /// When the text changes, highlight the text.
    override func didChangeText() {
        
        super.didChangeText()
        
        let a = self.selectedRange
        let code = self.string
        let highlightedCode = highlightr!.highlight(code, as: "C++")
        
        self.textStorage!.setAttributedString(highlightedCode!)
        self.setSelectedRange(a)
        
        self.codeTextViewDelegate?.didChangeText!(lines: self.textStorage?.paragraphs.count ?? 0, characters: self.textStorage?.characters.count ?? 0)
        self.gutterDelegate?.didChangeText!(lines: (self.textStorage?.paragraphs.count)!, characters: 0)
        
    }
    
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
                insertNewline(self)
                deleteBackward(self)
                super.insertText("}", replacementRange: replacementRange)
                self.selectedRange.location -= 1
            
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
        
        if let savedData = CDSettingsViewController.getSavedData() {
            
            config = savedData
            
        } else {
            
            initDefaultData()
            
        }
        
        self.highlightr!.setTheme(to: config!.lightThemeName)
        self.highlightr!.theme.setCodeFont(NSFont(name: config!.fontName, size: CGFloat(config!.fontSize))!)
        
    }
    
}
