//
//  CDGraphicCodeEditorViewController.swift
//  C+++
//
//  Created by 23786 on 2020/7/17.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

class CDGraphicalCodeEditorViewController: NSViewController, NSTextViewDelegate, NSTableViewDataSource, NSTableViewDelegate{
    
    @IBOutlet weak var splitView: NSSplitView!
    @IBOutlet weak var hiddenTextView: CDGraphicalCodeEditorHiddenTextView!
    @IBOutlet var includeCellViewExamole: CDGraphicalCodeEditorIncludeCellView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        let document = self.view.window?.windowController?.document
        self.representedObject = document
        
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
