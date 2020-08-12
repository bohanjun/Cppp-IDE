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




class CDMainViewController: NSViewController, NSTextViewDelegate, CDCodeEditorDelegate, NSSplitViewDelegate {
    
    
    func setStatus(string: String) {
        (self.view.window?.windowController as! CDMainWindowController).statusString = string
    }
    
    /// Whether the window is in dark mode or not.
    /// - If it is true,the appearance is dark aqua.
    /// - if it is false, the appearance is aqua.
    var isDarkMode: Bool = true
    var isOpeningInProjectViewController = false
    
    
    @IBOutlet weak var mainTextView: CDCodeEditor!
    @IBOutlet weak var pathControl: NSPathControl!
    @IBOutlet weak var rightConstraint: NSLayoutConstraint!
    @IBOutlet weak var fakeBackground: NSTextField!
    @IBOutlet weak var scrollViewOfTextView: CDCodeEditorScrollView!
    @IBOutlet weak var linesLabel: NSTextField!
    @IBOutlet weak var charactersLabel: NSTextField!
    @IBOutlet weak var compileView: NSView!
    @IBOutlet weak var consoleView: CDConsoleView!
    @IBOutlet weak var leftView: NSView!
    @IBOutlet weak var bigSplitView: NSSplitView!
    @IBOutlet weak var smallSplitView: NSSplitView!
    @IBOutlet weak var lineNumberView: CDCodeEditorLineNumberView!
    @IBOutlet weak var minimapView: CDMinimapView!
    @IBOutlet weak var minimapViewConstraint: NSLayoutConstraint!
    
    
    
    
    
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(settingsDidChange(_:)), name: CDSettings.settingsDidChangeNotification, object: nil)
        
        self.mainTextView.codeEditorDelegate = self
        self.mainTextView.scrollView = self.scrollViewOfTextView
            
        // set the font of the text view
        self.mainTextView.font = CDSettings.shared.font
        self.mainTextView.highlightr?.theme.setCodeFont(CDSettings.shared.font)
        
        self.consoleView.textView.font = menloFont(ofSize: 13.0)
        
        // initialize the scroll view and the minimap view.
        self.scrollViewOfTextView.scroll(self.scrollViewOfTextView.contentView, to: NSMakePoint(0, 0))
        
        // set the current appearance to Dark Mode
        if #available(OSX 10.14, *) {
            self.mainTextView.highlightr?.setTheme(to: CDSettings.shared.darkThemeName)
            self.view.window?.appearance = darkAqua
            self.view.appearance = darkAqua
            for view in self.view.subviews {
                view.appearance = darkAqua
            }
            self.isDarkMode = false
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
            if CDSettings.shared.showLiveIssues {
                self.updateDiagnostics()
            }
            
            let dataOfView = self.mainTextView.dataWithPDF(inside: self.mainTextView.bounds)
            let imageOfView = NSImage(data: dataOfView)
            self.minimapView.imageView.image = imageOfView
            self.minimapView.frame.size.height =  imageOfView!.size.height / (imageOfView!.size.width / self.minimapView.imageView.frame.width)
            self.minimapView.imageView.frame.size.height =  imageOfView!.size.height / (imageOfView!.size.width / self.minimapView.imageView.frame.width)
            
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
    
    override func viewWillAppear() {
        super.viewWillAppear()
        if !self.isOpeningInProjectViewController {
            self.representedObject = self.view.window?.windowController?.document as? CDCodeDocument
        }
    }
    
    
    
    
    
// MARK: - NSTextViewDelegate

    func textDidBeginEditing(_ notification: Notification) {
        document?.objectDidBeginEditing(self)
    }

    func textDidEndEditing(_ notification: Notification) {
        document?.objectDidEndEditing(self)
    }
    
    
    
    @IBAction func enterSimpleMode(_ sender: Any?) {
        
        self.leftView.isHidden = true
        self.rightConstraint.constant = 0.0
        self.compileView.isHidden = true
        self.consoleView.isHidden = true
        
    }
    
    @IBAction func toggleLeftSidebar(_ sender: Any?) {
        if self.leftView.isHidden {
            self.leftView.isHidden = false
        } else {
            self.leftView.isHidden = true
        }
    }
    
    @IBAction func toggleCompileInfoView(_ sender: Any?) {
        if self.consoleView.isHidden {
            self.consoleView.isHidden = false
        } else {
            self.consoleView.isHidden = true
        }
    }
    
    @IBAction func toggleCompileView(_ sender: Any?) {
        if self.compileView.isHidden {
            self.compileView.isHidden = false
            self.rightConstraint.constant = 253.0
        } else {
            self.compileView.isHidden = true
            self.rightConstraint.constant = 0.0
        }
    }
    
    @IBAction func toggleMinimap(_ sender: Any?) {
        if self.minimapView.enclosingScrollView!.isHidden {
            self.minimapView.enclosingScrollView?.isHidden = false
            self.minimapViewConstraint.constant = 123.0
        } else {
            self.minimapView.enclosingScrollView?.isHidden = true
            self.minimapViewConstraint.constant = 0.0
        }
    }
    
}
