//
//  CDGraphicCodeEditorViewController.swift
//  C+++
//
//  Created by 23786 on 2020/7/17.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

class CDGraphicalCodeEditorViewController: NSViewController, NSTextViewDelegate, CDGraphicalCodeEditorCellViewDelegate {
    
    @IBOutlet weak var splitView: NSSplitView!
    @IBOutlet weak var hiddenTextView: CDGraphicalCodeEditorHiddenTextView!
    @IBOutlet var viewInScrollView: CDFlippedView!
    var cellViews = [CDGraphicalCodeEditorIncludeCellView]()
    
    @IBOutlet var includeCellViewTemplate: CDGraphicalCodeEditorIncludeCellView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        let document = self.view.window?.windowController?.document
        self.representedObject = document
        self.loadGraphicalCode()
        
    }
    
    
    
    func loadGraphicalCode() {
        
        var y: CGFloat = 10
        var lineNumber = 1
        
        let lines = self.document?.lines ?? [String]()
        for line in lines {
            if line == "" || line == "\n" {
                continue
            } else {
                let type = line.components(separatedBy: "\n").first!
                print(type)
                switch type {
                    case "Include":
                        let data = NSKeyedArchiver.archivedData(withRootObject: self.includeCellViewTemplate!)
                        let view = NSKeyedUnarchiver.unarchiveObject(with: data) as! CDGraphicalCodeEditorIncludeCellView
                        view.resetIBOutlet()
                        view.loadStoredData(string: line)
                        view.frame.origin.y = y
                        view.setLineNumber(lineNumber)
                        view.backgroundTextField.cornerRadius = 8.0
                        self.viewInScrollView.addSubview(view)
                        self.cellViews.append(view)
                        y += (view.frame.height + 1)
                        lineNumber += 1
                    
                    default:
                        break
                }
            }
        }
        
    }
    
    
    func codeEditorCellViewDidChangeValue(_ view: CDGraphicalCodeEditorCellView) {
        
    }
    
    
    override var representedObject: Any? {
        didSet {
            // Pass down the represented object to all of the child view controllers.
            for child in children {
                child.representedObject = representedObject
            }
        }
    }

    weak var document: CDGraphicalCodeDocument? {
        if let docRepresentedObject = representedObject as? CDGraphicalCodeDocument {
            return docRepresentedObject
        }
        return nil
    }
    
    func textDidBeginEditing(_ notification: Notification) {
        document?.objectDidBeginEditing(self)
    }

    func textDidEndEditing(_ notification: Notification) {
        document?.objectDidEndEditing(self)
    }
    
}
