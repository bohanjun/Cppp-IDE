//
//  ViewController.swift
//  Code Editor
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





class CDMainViewController: NSViewController, NSTextViewDelegate, CDSettingsViewDelegate, CDCodeEditorDelegate, CDSnippetPopoverViewControllerDelegate {
    
// MARK: - Properties
    
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
    
    @IBOutlet var mainTextView: CDCodeEditor!
    @IBOutlet var lineNumberTextView: CDLineNumberTextView!
    @IBOutlet weak var pathControl: NSPathControl!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftConstraint: NSLayoutConstraint!
    @IBOutlet weak var fakeBackground: NSTextField!
    @IBOutlet weak var scrollViewOfTextView: CDLineNumberScrollView!
    @IBOutlet weak var linesLabel: NSTextField!
    @IBOutlet weak var charactersLabel: NSTextField!
    @IBOutlet var compileInfo: NSTextView!
    @IBOutlet weak var compileView: NSView!
    @IBOutlet weak var fileAndSnippetView: NSView!
    
    
    
    
    
    
// MARK: - viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mainTextView.codeEditorDelegate = self
        self.mainTextView.gutterDelegate = self.lineNumberTextView
        self.mainTextView.scrollView = self.scrollViewOfTextView
        
        // judge if there has already been a saved settings.
        if compileConfig != nil && config != nil {
            
            // set the font of the text view
            self.mainTextView.font = NSFont(name: config!.fontName, size: CGFloat(config!.fontSize))
            self.mainTextView.highlightr?.theme.setCodeFont(NSFont(name: config!.fontName, size: CGFloat(config!.fontSize))!)
            
        } else {
            
            // create default settings data
            initDefaultData()
            
        }
        
        // set the font of the StdIn, StdOut and the CompileInfo text view
        self.compileInfo.font = menloFont(ofSize: 13.0)
        
        // set the current appearance to Dark Mode.
        if #available(OSX 10.14, *) {
            self.mainTextView.highlightr?.setTheme(to: config!.darkThemeName)
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
    
    
    
    
    
    
    
    
// MARK: - Appearance
    
    // Change the appearance of the App. (OSX 10.14, *)
    @IBAction func changeAppearance(_ sender: Any) {
        
        if #available(OSX 10.14, *) {
        } else {
            if let _ = self.view.window {
                showAlert("Warning", "Your Mac does not support Dark Mode. Dark Mode requires macOS 10.14 Mojave or later. You should update your Mac.")
            }
            return
        }
        
        // judge the current appearance.
        switch isDarkMode {
            
            // Dark Mode
            case true:
                
                // Change the text view's highlight theme to Dark Mode.
                self.mainTextView.highlightr?.setTheme(to: config!.darkThemeName)
                
                // Chage the window's appearance to Dark Mode.
                if #available(OSX 10.14, *) {
                    self.view.window?.appearance = darkAqua
                    self.view.appearance = darkAqua
                    for view in self.view.subviews {
                        view.appearance = darkAqua
                    }
                    isDarkMode = false
                }
            
            // Light Mode
            case false:
                
                // Change the text view's highlight theme to Light Mode.
                self.mainTextView.highlightr?.setTheme(to: config!.lightThemeName)
                
                // Chage the window's appearance to Light Mode.
                if #available(OSX 10.14, *) {
                    self.view.window?.appearance = aqua
                    self.view.appearance = aqua
                    for view in self.view.subviews {
                        view.appearance = aqua
                    }
                    isDarkMode = true
                }
            
        }
        
        // Change the font of the text view.
        self.mainTextView.didChangeText()
        self.mainTextView.highlightr?.theme.setCodeFont(NSFont(name: config!.fontName, size: CGFloat(config!.fontSize))!)
        self.mainTextView.font = NSFont(name: config!.fontName, size: CGFloat(config!.fontSize))
        
    }
    
    @IBAction func showSettingsView(_ sender: Any) {
        
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        if let ViewController =
            storyboard.instantiateController(
                withIdentifier: NSStoryboard.SceneIdentifier("CDSettingsViewController")) as? CDSettingsViewController {
            ViewController.delegate = self
            self.presentAsSheet(ViewController)
        }
        
    }
    
    
    
    
    
// MARK: - SettingsViewDelegate
    
    func didSet() {
        
        // theme
        switch isDarkMode {
            case false:
                self.mainTextView.highlightr?.setTheme(to: config!.darkThemeName)
            case true:
                self.mainTextView.highlightr?.setTheme(to: config!.lightThemeName)
        }
        
        // font
        self.mainTextView.highlightr?.theme.setCodeFont(NSFont(name: config!.fontName, size: CGFloat(config!.fontSize))!)
        self.mainTextView.font = NSFont(name: config!.fontName, size: CGFloat(config!.fontSize))
        self.lineNumberTextView.font = NSFont(name: config!.fontName, size: CGFloat(config!.fontSize))
        self.mainTextView.didChangeText()
        
        // in case of errors
        changeAppearance(self)
        changeAppearance(self)
        
    }
    
    
    
    
    
    
// MARK: - CDTextViewDelegate
    
    
    func didChangeText(lines: Int, characters: Int) {
        
        self.linesLabel.stringValue = "\(lines) lines"
        self.charactersLabel.stringValue = "\(characters) characters"
        
    }
    

    
    
    
    

// MARK: - Segmented Control
    
    @IBOutlet weak var scrollViewOfTableView: NSScrollView!
    @IBOutlet weak var snippetTableView: CDSnippetTableView!
    @IBOutlet weak var addSnippetButton: NSButton!
    @IBOutlet weak var fileView: NSView!
    
    @IBAction func valueChanged(_ sender: NSSegmentedControl) {
        
        switch sender.selectedSegment {
            case 0:
                scrollViewOfTableView.isHidden = true
                addSnippetButton.isHidden = true
                fileView.isHidden = false
            
            case 1:
                fileView.isHidden = true
                scrollViewOfTableView.isHidden = false
                addSnippetButton.isHidden = false
                break
            default: break
        }
        
    }
    
// MARK: - CDTextViewCellInfoViewController
    
    private var popover: NSPopover!
    
    @IBAction func addItem(_ sender: NSButton) {
        
        let vc = CDSnippetPopoperViewController()
        vc.setup(title: "Edit your title", image: NSImage(named: "Code")!, code: "Edit your code here.\nYou can also click the image to\n change the color of it.", mode: true)
        vc.closeDelegate = self
        vc.delegate = self.snippetTableView
        popover = NSPopover()
        popover.behavior = .transient
        popover.contentViewController = vc
        popover.show(relativeTo: sender.bounds, of: sender, preferredEdge: .maxY)
        
    }
    
    func didAddToCode(code: String) {
        self.mainTextView.insertText(code, replacementRange: self.mainTextView.selectedRange)
    }
    
    func willClose() {
        popover.close()
    }
    
    
    
    
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
