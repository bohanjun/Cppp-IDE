//
//  ViewController.swift
//  C+++
//
//  Created by apple on 2020/3/23.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

func menloFont(ofSize size: CGFloat) -> NSFont {
    return NSFont(name: "Menlo", size: size)!
}



@available(OSX 10.14, *)
let darkAqua = NSAppearance(named: .darkAqua)
let aqua = NSAppearance(named: .aqua)




extension NSViewController {
    
    func showAlert(_ title: String, _ message: String) {
        
        guard self.view.window != nil else {
            return
        }
        
        let alert = NSAlert()
        alert.messageText = title
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK")
        alert.informativeText = message
        alert.beginSheetModal(for: self.view.window!, completionHandler: { returnCode in })
        
    }
    
}

extension String {
    
    /// Returns the index of the first substring in the string.
    /// - Parameters:
    ///   - string: The substring.
    /// - Returns: The index of the first substring in the string. -1 if not found.
    func firstIndexOf(_ string: String) -> Int {
        
        var pos = -1
        if let range = range(of: string, options: .literal) {
            if !range.isEmpty {
                pos = self.distance(from: startIndex, to: range.lowerBound)
            }
        }
        return pos
        
    }
    
}





class CDMainViewController: NSViewController, NSTextViewDelegate, CDCodeEditorDelegate, NSSplitViewDelegate {
    
    
    func setStatus(string: String) {
        (self.view.window?.windowController as! CDMainWindowController).statusString = string
    }
    
    /// Whether the window is in dark mode or not.
    /// - If it is true,the appearance is dark aqua.
    /// - if it is false, the appearance is aqua.
    var isDarkMode: Bool = true
    
    /// Whether the compile info view is hidden.
    var bottom = true
    
    /// Whether the compile view is hidden.
    var right = true
    
    /// Whether the file info view is hidden.
    var left = true
    
    
    
    @IBOutlet weak var mainTextView: CDCodeEditor!
    @IBOutlet weak var lineNumberTextView: CDLineNumberTextView!
    @IBOutlet weak var pathControl: NSPathControl!
    @IBOutlet weak var rightConstraint: NSLayoutConstraint!
    @IBOutlet weak var fakeBackground: NSTextField!
    @IBOutlet weak var scrollViewOfTextView: CDLineNumberScrollView!
    @IBOutlet weak var linesLabel: NSTextField!
    @IBOutlet weak var charactersLabel: NSTextField!
    @IBOutlet weak var compileInfo: NSTextView!
    @IBOutlet weak var compileView: NSView!
    @IBOutlet weak var leftView: NSView!
    @IBOutlet weak var bigSplitView: NSSplitView!
    @IBOutlet weak var smallSplitView: NSSplitView!
    
    
    
    
    
    
    
// MARK: - Split View Delegate
    
    func splitView(_ splitView: NSSplitView, canCollapseSubview subview: NSView) -> Bool {
        
        if subview == self.leftView {
            return true
        } else {
            return false
        }
        
    }
    
    
    
    
// MARK: - viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mainTextView.codeEditorDelegate = self
        self.mainTextView.gutterDelegate = self.lineNumberTextView
        self.mainTextView.scrollView = self.scrollViewOfTextView
        
        // judge if there has already been a saved settings.
        if CDSettings.shared != nil && CDCompileSettings.shared != nil {
            
            // set the font of the text view
            self.mainTextView.font = CDSettings.shared.font
            self.mainTextView.highlightr?.theme.setCodeFont(CDSettings.shared.font)
            
        } else {
            
            // create default settings data
            initDefaultData()
            
        }
        
        // set the font of the StdIn, StdOut and the CompileInfo text view
        self.compileInfo.font = menloFont(ofSize: 13.0)
        
        // set the current appearance to Dark Mode.
        if #available(OSX 10.14, *) {
            self.mainTextView.highlightr?.setTheme(to: CDSettings.shared.darkThemeName)
            self.view.window?.appearance = darkAqua
            self.view.appearance = darkAqua
            for view in self.view.subviews {
                view.appearance = darkAqua
            }
            isDarkMode = false
        }
        
        // in case of errors
        changeAppearance(self)
        changeAppearance(self)
        
    }
    
    
    
    
    
// MARK: - Code Editor Delegate
    
    
    func codeEditorDidChangeText(lines: Int, characters: Int) {
        
        DispatchQueue.main.async {
            
            self.linesLabel.stringValue = "\(lines) lines"
            self.charactersLabel.stringValue = "\(characters) characters"
            self.updateDiagnostics()
            
        }
        
    }
    

    
    
    
    
    

// MARK: - Segmented Control
    
    @IBOutlet weak var segmentedControl: NSSegmentedControl!
    @IBOutlet weak var scrollViewOfTableView: NSScrollView!
    @IBOutlet weak var snippetAndDiagnositcsTableView: CDSnippetTableView!
    @IBOutlet weak var addSnippetButton: NSButton!
    @IBOutlet weak var fileView: NSView!
    
   
    
// MARK: - Snippet Table View
    @IBOutlet weak var snippetSearchField: NSSearchField!
   
    
    
    
// MARK: - Diagnostics
    var diagnostics = [CKDiagnostic]()
    var diagnosticsCells = [CDSnippetTableViewCell]()
    
    
    
    
    
// MARK: - Document
    
    override var representedObject: Any? {
        didSet {
            // Pass down the represented object to all of the child view controllers.
            for child in children {
                child.representedObject = representedObject
            }
        }
    }

    weak var document: CDCodeDocument? {
        if let docRepresentedObject = representedObject as? CDCodeDocument {
            return docRepresentedObject
        }
        return nil
    }

    
    
    
    
    
// MARK: - NSTextViewDelegate

    func textDidBeginEditing(_ notification: Notification) {
        document?.objectDidBeginEditing(self)
    }

    func textDidEndEditing(_ notification: Notification) {
        document?.objectDidEndEditing(self)
    }
    
    
}
