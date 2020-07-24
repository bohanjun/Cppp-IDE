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
    var cellViews = [CDGraphicalCodeEditorCellView]()
    
    @IBOutlet var includeCellViewTemplate: CDGraphicalCodeEditorIncludeCellView!
    @IBOutlet var usingNamespaceCellViewTemplate: CDGraphicalCodeEditorUsingNamespaceCellView!
    @IBOutlet var ifCellViewTemplate: CDGraphicalCodeEditorIfCellView!
    
    func includeCellView() -> CDGraphicalCodeEditorIncludeCellView {
        
        let data = NSKeyedArchiver.archivedData(withRootObject: self.includeCellViewTemplate!)
        let viewCopy = NSKeyedUnarchiver.unarchiveObject(with: data) as! CDGraphicalCodeEditorIncludeCellView
        viewCopy.delegate = self
        viewCopy.isHidden = false
        viewCopy.reloadView()
        return viewCopy
        
    }
    
    func usingNamespaceCellView() -> CDGraphicalCodeEditorUsingNamespaceCellView {
        
        let data = NSKeyedArchiver.archivedData(withRootObject: self.usingNamespaceCellViewTemplate!)
        let viewCopy = NSKeyedUnarchiver.unarchiveObject(with: data) as! CDGraphicalCodeEditorUsingNamespaceCellView
        viewCopy.delegate = self
        viewCopy.isHidden = false
        viewCopy.reloadView()
        return viewCopy
        
    }
    
    func ifCellView() -> CDGraphicalCodeEditorIfCellView {
        
        let data = NSKeyedArchiver.archivedData(withRootObject: self.ifCellViewTemplate!)
        let viewCopy = NSKeyedUnarchiver.unarchiveObject(with: data) as! CDGraphicalCodeEditorIfCellView
        viewCopy.delegate = self
        viewCopy.isHidden = false
        viewCopy.reloadView()
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
    
    func cellViewOfType(type: String) -> CDGraphicalCodeEditorCellView? {
        
        var view: CDGraphicalCodeEditorCellView! = nil
        switch type {
            case "Include":
                view = self.includeCellView()
            case "UsingNamespace":
                view = self.usingNamespaceCellView()
            case "If":
                view = self.ifCellView()
            default:
                break
                
        }
        return view
        
    }
    
    func insertLine(type: String, at index: Int) {
        
        guard cellViews.count >= index else {
            return
        }
        
        let view = cellViewOfType(type: type)
        if view != nil {
            
            view!.loadSample()
            self.cellViews.insert(view!, at: index)
            
        } else {
            return
        }
        
        let string = self.viewInScrollView.load(cellViews: self.cellViews)
        self.hiddenTextView.string = ""
        self.hiddenTextView.insertText(string, replacementRange: NSMakeRange(0, 0))
        
    }
    
    
    
    
    
    func loadGraphicalCode() {
        
        let lines = self.document?.lines ?? [String]()
        var hierarchy = 0
        for line in lines {
            
            if line == "" || line == "\n" {
                continue
            } else {
                
                let type = line.components(separatedBy: "\n").first!
                
                if type == "BlockEnd" {
                    hierarchy -= 1
                    continue
                }
                
                let view = self.cellViewOfType(type: type)
                if view != nil {
                    view!.loadStoredData(string: line)
                }
                
                if view is CDGraphicalCodeEditorBlockCellView {
                    hierarchy += 1
                    if hierarchy - 1 == 0 {
                        view!.reloadView()
                        self.cellViews.append(view!)
                    } else {
                        let blockCellView =
                            (self.cellViews[self.cellViews.endIndex - 1] as! CDGraphicalCodeEditorBlockCellView)
                        blockCellView.addCellView(of: hierarchy - 1 - 1, view: view!)
                        blockCellView.reloadView()
                    }
                    continue
                }
                
                if hierarchy >= 1 {
                    
                    let blockCellView =
                        (self.cellViews[self.cellViews.endIndex - 1] as! CDGraphicalCodeEditorBlockCellView)
                    blockCellView.addCellView(of: hierarchy - 1, view: view!)
                    blockCellView.reloadView()
                    
                } else {
                    
                    self.cellViews.append(view!)
                    
                }
                
            }
            
        }
        
        self.hiddenTextView?.string = self.viewInScrollView.load(cellViews: self.cellViews)
        
    }
    
    
    
    func codeEditorView(_ view: CDGraphicalCodeEditorView, didDragToPoint point: NSPoint, type: String) {
        
        for (index, view) in self.cellViews.enumerated() {
            if view is CDGraphicalCodeEditorBlockCellView && view.frame.contains(point) {
                (view as! CDGraphicalCodeEditorBlockCellView).processDragAtPoint(point: point, view: self.cellViewOfType(type: type)!)
                self.hiddenTextView?.string = self.viewInScrollView.load(cellViews: self.cellViews)
                return
            }
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
    
    func deleteCodeEditorCellView(_ view: CDGraphicalCodeEditorCellView) {
        self.cellViews.remove(at: view.lineNumberButton.title.nsString.integerValue - 1)
        self.hiddenTextView?.string = self.viewInScrollView.load(cellViews: self.cellViews)
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
    
    
    @IBAction func generateCode(_ sender: Any?) {
        
        var code = "// Code Generated By C+++\n"
        for cell in self.cellViews {
            code += cell.code + "\n"
        }
        let storyboard = NSStoryboard(name: "Graphical Code Editor", bundle: nil)
        if let windowController = storyboard.instantiateController(withIdentifier: "Generated Code") as? NSWindowController {
            windowController.showWindow(self)
            (windowController.contentViewController as! CDGraphicalCodeEditorGeneratedCodeViewController).setCode(code: code)
            (windowController.contentViewController as! CDGraphicalCodeEditorGeneratedCodeViewController).codeEditor.didChangeText()
        }
        
    }
    
}
