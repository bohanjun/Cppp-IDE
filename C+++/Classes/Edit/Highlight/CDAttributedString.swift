//
//  CodeAttributedString.swift
//  C+++
//
//  Created by apple on 2020/3/26.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

/// Highlighting Delegate
@objc public protocol CDHighlightDelegate {
    /**
     If this method returns *false*, the highlighting process will be skipped for this range.
     - parameter range: NSRange
     - returns: Bool
     */
    @objc optional func shouldHighlight(_ range: NSRange) -> Bool
    
    /**
     Called after a range of the string was highlighted, if there was an error **success** will be *false*.
     - parameter range:   NSRange
     - parameter success: Bool
     */
    @objc optional func didHighlight(_ range: NSRange, success: Bool)
    
}

/// NSTextStorage subclass. Can be used to dynamically highlight code.
open class CDHighlightrAttributedString : NSTextStorage {
    
    /// Internal Storage
    let stringStorage = NSTextStorage()

    /// Highlightr instace used internally for highlighting. Use this for configuring the theme.
    public let highlightr: CDHighlightr
    
    /// This object will be notified before and after the highlighting.
    open var highlightDelegate : CDHighlightDelegate?

    
    // MARK: - Initializers
    public init(highlightr: CDHighlightr = CDHighlightr()!) {
        
        self.highlightr = highlightr
        super.init()
        setupListeners()
        
    }

    public override init() {
        self.highlightr = CDHighlightr()!
        super.init()
        setupListeners()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.highlightr = CDHighlightr()!
        super.init(coder: aDecoder)
        setupListeners()
    }
    
    required public init?(pasteboardPropertyList propertyList: Any, ofType type: NSPasteboard.PasteboardType) {
        
        self.highlightr = CDHighlightr()!
        super.init(pasteboardPropertyList: propertyList, ofType: type)
        setupListeners()
        
    }
    
    /// Language syntax to use for highlighting. Providing nil will disable highlighting.
    open var language : String? {
        didSet {
            highlight(NSMakeRange(0, stringStorage.length))
        }
    }
    
    /// Returns a standard String based on the current one.
    open override var string: String {
        get {
            return stringStorage.string
        }
    }
    
    /**
     Returns the attributes for the character at a given index.
     - parameter location: Int
     - parameter range:    NSRangePointer
     - returns: Attributes
     */
    open override func attributes(at location: Int, effectiveRange range: NSRangePointer?) -> [AttributedStringKey : Any] {
        return stringStorage.attributes(at: location, effectiveRange: range)
    }
    
    /**
     Replaces the characters at the given range with the provided string.
     - parameter range: NSRange
     - parameter str:   String
     */
    open override func replaceCharacters(in range: NSRange, with str: String) {
        stringStorage.replaceCharacters(in: range, with: str)
        
        self.edited(TextStorageEditActions.editedCharacters, range: range, changeInLength: str.nsString.length - range.length)
        
    }
    
    /**
     Sets the attributes for the characters in the specified range to the given attributes.
     - parameter attrs: [String : AnyObject]
     - parameter range: NSRange
     */
    open override func setAttributes(_ attrs: [AttributedStringKey : Any]?, range: NSRange) {
        
        stringStorage.setAttributes(attrs, range: range)
        self.edited(TextStorageEditActions.editedAttributes, range: range, changeInLength: 0)
        
    }
    
    /// Called internally everytime the string is modified.
    open override func processEditing() {
        super.processEditing()
        
        if language != nil {
            if self.editedMask.contains(.editedCharacters) {
                let string = self.string.nsString
                let range = string.paragraphRange(for: editedRange)
                highlight(range)
            }
        }
        
    }

    func highlight(_ range: NSRange) {
        
        if language == nil {
            return
        }
        
        if let highlightDelegate = highlightDelegate {
            let shouldHighlight: Bool? = highlightDelegate.shouldHighlight?(range)
            if shouldHighlight != nil && !shouldHighlight! {
                return
            }
        }
        
        let string = self.string.nsString
        let line = string.substring(with: range)
        
        DispatchQueue.global().async {
            let tmpStrg = self.highlightr.highlight(line, as: self.language!)
            DispatchQueue.main.async(execute: {
                //Checks to see if this highlighting is still valid.
                if (range.location + range.length) > self.stringStorage.length {
                    self.highlightDelegate?.didHighlight?(range, success: false)
                    return
                }
                
                if tmpStrg?.string != self.stringStorage.attributedSubstring(from: range).string {
                    self.highlightDelegate?.didHighlight?(range, success: false)
                    return
                }
                
                self.beginEditing()
                tmpStrg?.enumerateAttributes(in: NSMakeRange(0, (tmpStrg?.length)!), options: [], using: { (attrs, locRange, stop) in
                    var fixedRange = NSMakeRange(range.location+locRange.location, locRange.length)
                    fixedRange.length = (fixedRange.location + fixedRange.length < string.length) ? fixedRange.length : string.length - fixedRange.location
                    fixedRange.length = (fixedRange.length >= 0) ? fixedRange.length : 0
                    self.stringStorage.setAttributes(attrs, range: fixedRange)
                })
                self.endEditing()
                self.edited(TextStorageEditActions.editedAttributes, range: range, changeInLength: 0)
                self.highlightDelegate?.didHighlight?(range, success: true)
                
            })
            
        }
        
    }
    
    func setupListeners() {
        
        highlightr.themeChanged = {
            _ in self.highlight(NSMakeRange(0, self.stringStorage.length))
        }
        
    }
    
}
