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


class ViewController: NSViewController, NSTextViewDelegate, SettingsViewDelegate {
    
    
// MARK: - Properties
    
    
    // Normal Editing
    @IBOutlet var TextView: CDTextView!
    
    @IBOutlet weak var BottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var RightConstraint: NSLayoutConstraint!
    @IBOutlet weak var FakeBackgroundAddition: NSTextField!
    @IBOutlet weak var TextView_ScrollView: NSScrollView!
    @IBOutlet weak var Option: NSButton!
    
    // Compiling
    @IBOutlet weak var FileName: NSTextField!
    @IBOutlet weak var FolderName: NSTextField!
    @IBOutlet var StdIn: NSTextView!
    @IBOutlet var StdOut: NSTextView!
    @IBOutlet var CompileInfo: NSTextView!
    
    
    
    
// MARK: - Methods
    @IBAction func Compile(_ sender: Any) {
        
        let file = FileName.stringValue
        let folder = FolderName.stringValue
        let stdin = StdIn.string + "\nEOF\n"
        let option = self.Option.state == .on
        let res = CompileSource(folder, fileURL: file, stdin: stdin, openInTerminal: option)
        
        self.StdOut.string = res[1]
        self.CompileInfo.string = res[0]
        
    }
    
    func fillInPath(_ sender: Any) {
        
        var tmp = self.FileName.stringValue.components(separatedBy: "/")
        tmp.removeLast()
        let res = tmp.joined(separator: "/")
        self.FolderName.stringValue = res
        
    }
    
    
    
// MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if SettingsViewController.getSavedData() != nil &&
            SettingsViewController.getSavedData2() != nil {
            
            config = SettingsViewController.getSavedData()
            compileConfig = SettingsViewController.getSavedData2()
            
        } else {
            
            initDefaultData()
            
        }
        
        self.StdIn.font = MenloFont(ofSize: 14.0)
        self.TextView.delegate = self
        self.StdOut.font = MenloFont(ofSize: 14.0)
        self.CompileInfo.font = MenloFont(ofSize: 13.0)
        
        if #available(OSX 10.14, *) {
            self.TextView.highlightr?.setTheme(to: config.DarkThemeName)
            self.view.window?.appearance = darkAqua
            self.view.appearance = darkAqua
            for view in self.view.subviews {
                view.appearance = darkAqua
            }
            status = false
        }
    }
    
    
// MARK: - Appearance
    
    @IBAction func changeAppearance(_ sender: Any) {
        
        switch status {
            
            case true:
                
                self.TextView.highlightr?.setTheme(to: config.DarkThemeName)
                
                if #available(OSX 10.14, *) {
                    self.view.window?.appearance = darkAqua
                    self.view.appearance = darkAqua
                    for view in self.view.subviews {
                        view.appearance = darkAqua
                    }
                    status = false
                }
         
            case false:
                
                self.TextView.highlightr?.setTheme(to: config.LightThemeName)
                
                if #available(OSX 10.14, *) {
                    self.view.window?.appearance = aqua
                    self.view.appearance = aqua
                    for view in self.view.subviews {
                        view.appearance = aqua
                    }
                    status = true
                }
            
        }
        
        self.TextView.didChangeText()
        self.TextView.highlightr?.theme.setCodeFont(NSFont(name: config.FontName, size: CGFloat(config.FontSize))!)
        self.TextView.font = NSFont(name: config.FontName, size: CGFloat(config.FontSize))
        
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
                self.TextView.highlightr?.setTheme(to: config.DarkThemeName)
            case true:
                self.TextView.highlightr?.setTheme(to: config.LightThemeName)
        }
        
        // font
        self.TextView.highlightr?.theme.setCodeFont(NSFont(name: config.FontName, size: CGFloat(config.FontSize))!)
        self.TextView.font = NSFont(name: config.FontName, size: CGFloat(config.FontSize))
        self.TextView.didChangeText()
        
        // in case of errors
        changeAppearance(self)
        changeAppearance(self)
        
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
