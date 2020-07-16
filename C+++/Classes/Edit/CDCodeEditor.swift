//
//  CDTextView.swift
//  C+++
//
//  Created by apple on 2020/3/23.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

var codeCompletionViewController : CDCodeCompletionViewController!

extension String {
    
    var nsString: NSString {
        return NSString(string: self)
    }
    
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
    var codeAttributedString: CDHighlightrAttributedString!
    
    
    
    
    
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
            self.codeEditorDelegate?.codeEditorDidChangeText!(lines: self.textStorage?.paragraphs.count ?? 0, characters: self.textStorage?.characters.count ?? 0)
            self.gutterDelegate?.codeEditorDidChangeText!(lines: (self.textStorage?.paragraphs.count)!, currentLine: self.string.lineNumber(at: self.selectedRange.location)!)
            
        }
        
    }
    
    
    
    
    /// Inserts the given string into the receiver, replacing the specified content. Overriden to support automatic completion.
    /// - Parameters:
    ///   - string: The text to insert, either an NSString or NSAttributedString instance.
    ///   - replacementRange: The range of content to replace in the receiver’s text storage.
    open override func insertText(_ string: Any, replacementRange: NSRange) {
        super.insertText(string, replacementRange: replacementRange)
        
        if CDSettings.shared.autoComplete == false {
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
    
    
    private var lastTimeCompletionResults = [CDCompletionResult]()
    
    open override func completions(forPartialWordRange charRange: NSRange, indexOfSelectedItem index: UnsafeMutablePointer<Int>) -> [String]? {
       
        var completionResults = [CDCompletionResult]()
        
        let substring = self.string.nsString.substring(with: charRange)
        if substring == "" {
            return [String]()
        }
        
        
        if charRange.length == 1 {
            
            let line = self.string.lineNumber(at: self.selectedRange.location) ?? 0
            let column = self.string.columnNumber(at: self.selectedRange.location)
            let results = CKTranslationUnit(text: self.string, language: CKLanguageCPP).completionResults(forLine: UInt(line), column: UInt(column))
            
            if results != nil {
                
                var returnType: String!
                var typedText = ""
                var otherTexts = [String]()
                var type: CDCompletionResult.ResultType = .other
                
                for result in results! {
                    if let _result = result as? CKCompletionResult {
                        
                        switch _result.cursorKind {
                            
                            case CKCursorKindEnumDecl, CKCursorKindEnumConstantDecl: type = .enum
                            case CKCursorKindFunctionDecl, CKCursorKindFunctionTemplate, CKCursorKindConversionFunction, CKCursorKindCXXFunctionalCastExpr: type = .function
                            case CKCursorKindNamespace, CKCursorKindNamespaceRef, CKCursorKindNamespaceAlias: type = .namespace
                            case CKCursorKindVarDecl, CKCursorKindVariableRef: type = .variable
                            case CKCursorKindStructDecl: type = .struct
                            case CKCursorKindClassDecl: type = .class
                            case CKCursorKindMacroExpansion, CKCursorKindMacroDefinition, CKCursorKindMacroInstantiation, CKCursorKindLastPreprocessing, CKCursorKindFirstPreprocessing, CKCursorKindPreprocessingDirective: type = .preprocessing
                            case CKCursorKindTypeAliasDecl, CKCursorKindTypedefDecl: type = .typealias
                            
                            default: break
                            
                        }
                        
                        otherTexts = [String]()
                        
                        for chunk in _result.chunks {
                            if let _chunk = chunk as? CKCompletionChunk {
                                
                                switch _chunk.kind {
                                    case CKCompletionChunkKindResultType:
                                        returnType = _chunk.text
                                    case CKCompletionChunkKindTypedText:
                                        typedText = _chunk.text
                                    case CKCompletionChunkKindPlaceholder:
                                        otherTexts.append("{\(_chunk.text!)}")
                                    default:
                                        otherTexts.append(_chunk.text)
                                }
                                
                                
                            }
                            
                        }
                        
                        let completionResult = CDCompletionResult(returnType: returnType, typedText: typedText, otherTexts: otherTexts)
                        completionResult.type = type
                        completionResults.append(completionResult)
                        
                    }
                    
                }
                
            }
            
            var array = [CDCompletionResult]()
            for result in completionResults {
                if result.typedText.lowercased().hasPrefix(substring.lowercased()) && substring.count != result.typedText.count {
                    array.append(result)
                }
            }
            completionResults = array
            
            self.lastTimeCompletionResults = completionResults
            
            
        } else {
            
            var array = [CDCompletionResult]()
            for result in lastTimeCompletionResults {
                if result.typedText.lowercased().hasPrefix(substring.lowercased()) && substring.count != result.typedText.count {
                    array.append(result)
                }
            }
            completionResults = array
            
        }
        
        guard completionResults.count > 0 else {
            return [String]()
        }
                
        DispatchQueue.main.async {
                    
            let vc = CDCodeCompletionViewController()
            vc.delegate = self
            vc.results = completionResults
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
        self.lastTimeCompletionResults = []
    }
    
    
    // MARK: - init(coder:)
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.textContainer?.size = NSSize(width: CGFloat(Int.max), height: CGFloat(Int.max))
        self.textContainer?.widthTracksTextView = false
        
        if CDSettings.shared == nil {
            initDefaultData()
        }
        
        self.highlightr!.setTheme(to: CDSettings.shared.lightThemeName)
        self.highlightr!.theme.setCodeFont(CDSettings.shared.font)
        
    }
    
}
