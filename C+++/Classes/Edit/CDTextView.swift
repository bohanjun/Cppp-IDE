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
    "\"" : "\"",
    "\'" : "\'"
]

let completion2 = [
    "]" : "]",
    ")" : ")",
    "\"" : "\"",
    "\'" : "\'"
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

class CDTextView: NSTextView {

    let highlightr = Highlightr()
    var gutterDelegate: CDTextViewDelegate!
    var scrollView: CDScrollView!
    var codeTextViewDelegate: CDTextViewDelegate!
    var codeAttributedString: CodeAttributedString!
    
    
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
    
    /// shouldChangeText(in:replacementString:)
    override func shouldChangeText(in affectedCharRange: NSRange, replacementString: String?) -> Bool {
        
        let superResult = super.shouldChangeText(in: affectedCharRange, replacementString: replacementString)
        
        if let left = replacementString {
            
            if config.AutoComplete == false {
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
            if let str = completion2[left] {
                let range = self.selectedRange.location
                if self.string.count <= range {
                    return true
                }
                let string = NSString(string: self.string).substring(with: NSMakeRange(range, 1))
                if string == str && (self.string.challenge("(") == self.string.challenge(")")) {
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
    
    
    // MARK: - init(coder:)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.textContainer?.size = NSSize(width: CGFloat(Int.max), height: CGFloat(Int.max))
        self.textContainer?.widthTracksTextView = false
        
        if let savedData = SettingsViewController.getSavedData() {
            
            config = savedData
            
        } else {
            
            initDefaultData()
            
        }
        
        self.highlightr!.setTheme(to: config.LightThemeName)
        self.highlightr!.theme.setCodeFont(NSFont(name: config.FontName, size: CGFloat(config.FontSize))!)
        
    }
    
    init(frame: NSRect, textContainer: NSTextContainer) {
        super.init(frame: frame, textContainer: textContainer)
    }
    
}

/*
     aTextView.delegate = self
     let string = "Lorem ipsum dolor sit amet"
     var regexPatternForFullLinks: NSRegularExpression? = nil
     do {
         regexPatternForFullLinks = try NSRegularExpression(
             pattern: "(\\.\\.\\s(.*?\\.png))",
             options: .caseInsensitive)
     } catch {
     }
     let arrayOfAllMatches = regexPatternForFullLinks?.matches(in: string, options: [], range: NSRange(location: 0, length: string.count))
     var links: [AnyHashable] = []
     for match in arrayOfAllMatches ?? [] {
         links.append(((string as NSString).substring(with: match.range)).replacingOccurrences(of: ".. image:: ", with: "/"))
     }
     let modifiedString = regexPatternForFullLinks.stringByReplacingMatches(
         in: string,
         options: [],
         range: NSRange(location: 0, length: string.length()),
         withTemplate: "[Image]")
     var regexPatternReplaceLinksWithIMAGEStr: NSRegularExpression? = nil
     do {
         regexPatternReplaceLinksWithIMAGEStr = try NSRegularExpression(
             pattern: "\\[image\\]",
             options: .caseInsensitive)
     } catch {
     }
     var attrString = NSMutableAttributedString(string: modifiedString)
     let arrayOfAllMatchesImageText = regexPatternReplaceLinksWithIMAGEStr?.matches(
         in: modifiedString,
         options: [],
         range: NSRange(location: 0, length: modifiedString.count))
     for i in 0..<arrayOfAllMatchesImageText.count {
             let checkingResult = arrayOfAllMatchesImageText[i] as? NSTextCheckingResult
             attrString.beginEditing()
             if let range = checkingResult?.range {
                 attrString.addAttribute(.link, value: links[i], range: range)
             }
             if let range = checkingResult?.range {
                 attrString.addAttribute(.foregroundColor, value: NSColor.green, range: range)
             }
             if let range = checkingResult?.range {
                 attrString.addAttribute(.underlineStyle, value: NSNumber(value: 0), range: range)
             }
             attrString.endEditing()
         }
     aTextView.textStorage?.setAttributedString(attrString)
*/
