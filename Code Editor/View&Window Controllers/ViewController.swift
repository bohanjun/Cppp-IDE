//
//  ViewController.swift
//  Code Editor
//
//  Created by apple on 2020/3/23.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

func MenloFont(ofSize size: CGFloat) -> NSFont {
    return NSFont(name: "Menlo", size: size)!
}

var status: Bool = true

@available(OSX 10.14, *)
let darkAqua = NSAppearance(named: .darkAqua)
let aqua = NSAppearance(named: .aqua)

extension NSViewController {
    func showAlert(_ message: String, _ title: String) {
        let alert = NSAlert()
        alert.messageText = message
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK")
        alert.informativeText = title
        alert.beginSheetModal(for: self.view.window!, completionHandler: { returnCode in })
    }
}

class ViewController: NSViewController, NSTextViewDelegate, SettingsViewDelegate, CDTextViewDelegate {
    
// MARK: - Properties
    
    
    // Normal Editing
    @IBOutlet var TextView: CDTextView!
    @IBOutlet var gutterTextView: GutterTextView!
    
    // View Control
    @IBOutlet weak var BottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var RightConstraint: NSLayoutConstraint!
    @IBOutlet weak var FakeBackgroundAddition: NSTextField!
    @IBOutlet weak var TextView_ScrollView: NSScrollView!
    @IBOutlet weak var linesLabel: NSTextField!
    @IBOutlet weak var charactersLabel: NSTextField!
    
    // Compiling
    @IBOutlet weak var FileName: NSTextField!
    @IBOutlet var CompileInfo: NSTextView!
    
    
    
    
// MARK: - Methods
    
    // compile the code.
    @IBAction func Compile(_ sender: Any) {
        
        if FileName.stringValue == "" {
            showAlert("Warning", "You haven't filled in the \"File Path\", so the compiler don't know which file to compile. Save the file first and the file path will be filled in the text box automatically. If the text box is not filled in automatically, try again.")
            return
        }
        
        let file = FileName.stringValue
        let res = CompileSource(fileURL: file)
        
        self.CompileInfo.string = res
        
    }
    
    
    
// MARK: - viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.TextView.codeTextViewDelegate = self
        self.TextView.gutterDelegate = self.gutterTextView
        
        // judge if there has already been a saved settings.
        if SettingsViewController.getSavedData() != nil &&
            SettingsViewController.getSavedData2() != nil {
            
            // evaluate the config and compileConfig.
            config = SettingsViewController.getSavedData()
            compileConfig = SettingsViewController.getSavedData2()
            
            // set the font of the text view.
            self.TextView.font = NSFont(name: SettingsViewController.getSavedData()!.FontName, size: CGFloat(SettingsViewController.getSavedData()!.FontSize))
            self.TextView.highlightr?.theme.setCodeFont(NSFont(name: SettingsViewController.getSavedData()!.FontName, size: CGFloat(SettingsViewController.getSavedData()!.FontSize))!)
            
        } else {
            
            // create default settings data.
            initDefaultData()
            
        }
        
        // set the font of the StdIn, StdOut and the CompileInfo text view.
        self.CompileInfo.font = MenloFont(ofSize: 13.0)
        
        // set the current appearance to Dark Mode.
        if #available(OSX 10.14, *) {
            self.TextView.highlightr?.setTheme(to: SettingsViewController.getSavedData()!.DarkThemeName)
            self.view.window?.appearance = darkAqua
            self.view.appearance = darkAqua
            for view in self.view.subviews {
                view.appearance = darkAqua
            }
            status = false
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
            showAlert("Warning", "Your Mac does not support Dark Mode. Dark Mode requires macOS 10.14 or later. You can update your Mac.")
            return
        }
        
        // judge the current appearance.
        switch status {
            
            // Dark Mode
            case true:
                
                // Change the text view's highlight theme to Dark Mode.
                self.TextView.highlightr?.setTheme(to: SettingsViewController.getSavedData()!.DarkThemeName)
                
                // Chage the window's appearance to Dark Mode.
                if #available(OSX 10.14, *) {
                    self.view.window?.appearance = darkAqua
                    self.view.appearance = darkAqua
                    for view in self.view.subviews {
                        view.appearance = darkAqua
                    }
                    status = false
                }
            
            // Light Mode
            case false:
                
                // Change the text view's highlight theme to Light Mode.
                self.TextView.highlightr?.setTheme(to: SettingsViewController.getSavedData()!.LightThemeName)
                
                // Chage the window's appearance to Light Mode.
                if #available(OSX 10.14, *) {
                    self.view.window?.appearance = aqua
                    self.view.appearance = aqua
                    for view in self.view.subviews {
                        view.appearance = aqua
                    }
                    status = true
                }
            
        }
        
        // Change the font of the text view.
        self.TextView.didChangeText()
        self.TextView.highlightr?.theme.setCodeFont(NSFont(name: SettingsViewController.getSavedData()!.FontName, size: CGFloat(SettingsViewController.getSavedData()!.FontSize))!)
        self.TextView.font = NSFont(name: SettingsViewController.getSavedData()!.FontName, size: CGFloat(SettingsViewController.getSavedData()!.FontSize))
        
        
        
    }
    
    @IBAction func showSettingsView(_ sender: Any) {
        
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        if let ViewController =
            storyboard.instantiateController(
                withIdentifier: NSStoryboard.SceneIdentifier("SettingsViewController")) as? SettingsViewController {
            ViewController.delegate = self
            self.presentAsSheet(ViewController)
        }
        
    }
    
    
// MARK: - SettingsViewDelegate
    
    func didSet() {
        
        // theme
        switch status {
            case false:
                self.TextView.highlightr?.setTheme(to: SettingsViewController.getSavedData()!.DarkThemeName)
            case true:
                self.TextView.highlightr?.setTheme(to: SettingsViewController.getSavedData()!.LightThemeName)
        }
        
        // font
        self.TextView.highlightr?.theme.setCodeFont(NSFont(name: SettingsViewController.getSavedData()!.FontName, size: CGFloat(SettingsViewController.getSavedData()!.FontSize))!)
        self.TextView.font = NSFont(name: SettingsViewController.getSavedData()!.FontName, size: CGFloat(SettingsViewController.getSavedData()!.FontSize))
        self.gutterTextView.font = NSFont(name: SettingsViewController.getSavedData()!.FontName, size: CGFloat(SettingsViewController.getSavedData()!.FontSize))
        self.TextView.didChangeText()
        
        // in case of errors
        changeAppearance(self)
        changeAppearance(self)
        
    }
    
// MARK: - CDTextViewDelegate
    
    
    func didChangeText(lines: Int, characters: Int) {
        
        self.linesLabel.stringValue = "\(lines) lines"
        self.charactersLabel.stringValue = "\(characters) characters"
        
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

    weak var document: Document? {
        if let docRepresentedObject = representedObject as? Document {
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
