//
//  CDTextView.swift
//  Code Editor
//
//  Created by apple on 2020/3/23.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

var codeCompletionViewController : CDCodeCompletionViewController!

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
    
    func columnNumber(at position: Int) -> Int {
        
        var columnNumber = 0
        var characterPosition = 0
        for line in self.components(separatedBy: .newlines) {
            columnNumber = 0
            for _ in line {
                characterPosition += 1
                columnNumber += 1
                if characterPosition == position {
                    return columnNumber
                }
            }
            characterPosition += 1
            columnNumber += 1
            if characterPosition == position {
                return columnNumber
            }
        }
        return 1
        
    }
    
    var isIdentifier: Bool {
        get {
            if self.count == 0 {
                return true
            }
            if !(Array(self)[1].isLetter || Array(self)[1] == "_") {
                return false
            }
            for (i, char) in Array(self).enumerated() {
                if i == 0 {
                    continue
                }
                if !(char.isLetter || char.isNumber || char == "_") {
                    return false
                }
            }
            return true
        }
    }

}




open class CDCodeEditor: NSTextView, CDCodeCompletionViewControllerDelegate {
    

    let highlightr = CDHighlightr()
    var gutterDelegate: CDCodeEditorDelegate!
    var scrollView: CDLineNumberScrollView!
    var codeEditorDelegate: CDCodeEditorDelegate!
    weak var document: CDCodeDocument!
    var codeAttributedString: CDAttributedString!
    
    
    
    
    
    /// When the text changes, highlight the text.
    open override func didChangeText() {
        
        super.didChangeText()
        
        let selectedRange = self.selectedRange
        let code = self.string
        let highlightedCode = highlightr!.highlight(code, as: "C++")
        
        self.textStorage!.setAttributedString(highlightedCode!)
        self.setSelectedRange(selectedRange)
        
        DispatchQueue.main.async {
            
            self.complete(self)
            self.codeEditorDelegate?.didChangeText!(lines: self.textStorage?.paragraphs.count ?? 0, characters: self.textStorage?.characters.count ?? 0)
            self.gutterDelegate?.didChangeText!(lines: (self.textStorage?.paragraphs.count)!, currentLine: self.string.lineNumber(at: self.selectedRange.location)!)
            
        }
        
    }
    
    
    
    /// Inserts the given string into the receiver, replacing the specified content. Overriden to support automatic completion.
    /// - Parameters:
    ///   - string: The text to insert, either an NSString or NSAttributedString instance.
    ///   - replacementRange: The range of content to replace in the receiver’s text storage.
    open override func insertText(_ string: Any, replacementRange: NSRange) {
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
    open override func insertNewline(_ sender: Any?) {
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
    
    
    open override func completions(forPartialWordRange charRange: NSRange, indexOfSelectedItem index: UnsafeMutablePointer<Int>) -> [String]? {
        
        func compare(_ a: String, _ b: String) -> Int {
            var cnt: Int = 0
            if a.count > b.count || a.count == 0 || b.count == 0 {
                return 0
            } else {
                for (index, c) in Array(a).enumerated() {
                    if Array(b)[index].lowercased() == c.lowercased() {
                        cnt += 1
                    }
                }
            }
            return cnt
        }
        
        let line = self.string.lineNumber(at: self.selectedRange.location) ?? 0
        let column = self.string.columnNumber(at: self.selectedRange.location)
        let results = CKTranslationUnit(text: self.string, language: CKLanguageCPP).completionResults(forLine: UInt(line), column: UInt(column))
        var completionResults = [CDCompletionResult]()
        
        if results != nil {
            
            var returnType: String!
            var typedText = ""
            var otherTexts = [String]()
            
            for result in results! {
                if let _result = result as? CKCompletionResult {
                    
                    otherTexts = [String]()
                    
                    for chunk in _result.chunks {
                        if let _chunk = chunk as? CKCompletionChunk {
                            
                            
                            switch _chunk.kind {
                                case CKCompletionChunkKindResultType:
                                    returnType = _chunk.text
                                case CKCompletionChunkKindTypedText:
                                    typedText = _chunk.text
                                case CKCompletionChunkKindPlaceholder:
                                    otherTexts.append("(\(_chunk.text!))")
                                default:
                                    otherTexts.append(_chunk.text)
                            }
                            
                            
                        }
                        
                    }
                    
                    let completionResult = CDCompletionResult(returnType: returnType, typedText: typedText, otherTexts: otherTexts)
                    completionResults.append(completionResult)
                    
                }
                
            }
            
        }
        
        var finalRes = [CDCompletionResult]()
        let substring = (self.string as NSString).substring(with: charRange)
        for result in completionResults {
            if compare(substring, result.typedText) == substring.count {
                finalRes.append(result)
            }
        }
        
        guard finalRes.count > 0 else {
            return [String]()
        }
                
        DispatchQueue.main.async {
                    
            let vc = CDCodeCompletionViewController()
            vc.delegate = self
            vc.results = finalRes
            vc.range = charRange
            var rect = self.layoutManager?.boundingRect(forGlyphRange: self.selectedRange, in: self.textContainer!)
                rect?.size.width = 1.0
            DispatchQueue.main.async {
                vc.openInPopover(relativeTo: rect!, of: self, preferredEdge: .maxY)
                C___.codeCompletionViewController?.closePopover()
                C___.codeCompletionViewController = vc
            }
            
        }
                
        return [String]()
        
    }
    
    
    func codeCompletionViewController(_ viewController: CDCodeCompletionViewController, didSelectItemWithTitle title: String, range: NSRange) {
        self.insertCompletion(title, forPartialWordRange: range, movement: NSTextMovement.return.rawValue, isFinal: true)
    }
    
    
    open override func complete(_ sender: Any?) {
        super.complete(sender)
    }
    
    
    open override func insertCompletion(_ word: String, forPartialWordRange charRange: NSRange, movement: Int, isFinal flag: Bool) {
        super.insertCompletion(word, forPartialWordRange: charRange, movement: movement, isFinal: flag)
    }
    
    
    // MARK: - init(coder:)
    required public init?(coder: NSCoder) {
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
