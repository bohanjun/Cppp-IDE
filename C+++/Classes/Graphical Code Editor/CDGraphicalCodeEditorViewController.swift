//
//  CDGraphicCodeEditorViewController.swift
//  C+++
//
//  Created by 23786 on 2020/7/17.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

class CDGraphicalCodeEditorViewController: NSViewController, NSTextViewDelegate, CDGraphicalCodeEditorCellViewDelegate, CDGraphicalCodeEditorViewDelegate {
    
    @IBOutlet weak var splitView: NSSplitView!
    @IBOutlet weak var hiddenTextView: CDGraphicalCodeEditorHiddenTextView!
    @IBOutlet var viewInScrollView: CDGraphicalCodeEditorView!
    @IBOutlet weak var scrollViewHeightConstraint: NSLayoutConstraint!
    var cellViews = [CDGraphicalCodeEditorCellView]()
    
    @IBOutlet var includeCellViewTemplate: CDGraphicalCodeEditorIncludeCellView!
    @IBOutlet var usingNamespaceCellViewTemplate: CDGraphicalCodeEditorUsingNamespaceCellView!
    
    func includeCellView() -> CDGraphicalCodeEditorIncludeCellView {
        
        let data = NSKeyedArchiver.archivedData(withRootObject: self.includeCellViewTemplate!)
        let viewCopy = NSKeyedUnarchiver.unarchiveObject(with: data) as! CDGraphicalCodeEditorIncludeCellView
        viewCopy.isHidden = false
        viewCopy.resetIBOutlet()
        return viewCopy
        
    }
    
    func usingNamespaceCellView() -> CDGraphicalCodeEditorUsingNamespaceCellView {
        
        let data = NSKeyedArchiver.archivedData(withRootObject: self.usingNamespaceCellViewTemplate!)
        let viewCopy = NSKeyedUnarchiver.unarchiveObject(with: data) as! CDGraphicalCodeEditorUsingNamespaceCellView
        viewCopy.isHidden = false
        viewCopy.resetIBOutlet()
        return viewCopy
        
    }

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
    
    func insertLine(type: String, at index: Int) {
        
        guard cellViews.count >= index else {
            return
        }
        
        var view: CDGraphicalCodeEditorCellView! = nil
        
        switch type {
            
            case "Include":
                view = self.includeCellView()
                
            case "UsingNamespace":
                view = self.usingNamespaceCellView()
                
            default:
                break
                
        }
        
        if view != nil {
            
            view.isHidden = false
            view.resetIBOutlet()
            view.loadSample()
            self.viewInScrollView.addSubview(view)
            self.cellViews.insert(view, at: index)
            
        } else {
            return
        }
        
        var string = ""
        for view in self.cellViews {
            string += view.storedData
        }
        self.viewInScrollView.load(cellViews: self.cellViews)
        self.hiddenTextView.string = string
        
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
                var view: CDGraphicalCodeEditorCellView! = nil
                
                switch type {
                    
                    case "Include":
                        let data = NSKeyedArchiver.archivedData(withRootObject: self.includeCellViewTemplate!)
                        let viewCopy = NSKeyedUnarchiver.unarchiveObject(with: data) as! CDGraphicalCodeEditorIncludeCellView
                        view = viewCopy
                        
                    case "UsingNamespace":
                        let data = NSKeyedArchiver.archivedData(withRootObject: self.usingNamespaceCellViewTemplate!)
                        let viewCopy = NSKeyedUnarchiver.unarchiveObject(with: data) as! CDGraphicalCodeEditorUsingNamespaceCellView
                        view = viewCopy
                        
                    default:
                        break
                        
                }
                
                if view != nil {
                    
                    view.isHidden = false
                    view.resetIBOutlet()
                    view.loadStoredData(string: line)
                    view.frame.origin.y = y
                    view.setLineNumber(lineNumber)
                    self.viewInScrollView.addSubview(view)
                    self.cellViews.append(view)
                    y += (view.frame.height + 1)
                    lineNumber += 1
                    
                }
                
            }
            
        }
        
    }
    
    func codeEditorView(_ view: CDGraphicalCodeEditorView, didDragToPoint point: NSPoint, type: String) {
        
        print("DidDrag")
        for (index, view) in self.cellViews.enumerated() {
            if abs(view.frame.origin.y - point.y) <= 15.0 {
                self.insertLine(type: type, at: index)
                return
            }
        }
        self.insertLine(type: type, at: cellViews.endIndex)
        
    }
    
    func cellViewsInCodeEditorView(_ view: CDGraphicalCodeEditorView) -> [CDGraphicalCodeEditorCellView] {
        return self.cellViews
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
