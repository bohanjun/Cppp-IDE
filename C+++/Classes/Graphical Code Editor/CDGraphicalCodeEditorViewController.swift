//
//  CDGraphicCodeEditorViewController.swift
//  C+++
//
//  Created by 23786 on 2020/7/17.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

class CDGraphicalCodeEditorViewController: NSViewController, NSTextViewDelegate, NSTableViewDataSource {
    
    @IBOutlet weak var splitView: NSSplitView!
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var hiddenTextView: CDGraphicalCodeEditorHiddenTextView!
    
    // MARK: - NSTableViewDataSource
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        //return self.document?.numberOfRows ?? 0
        return 10
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        if tableColumn?.title == "Line" {
            return "\(row + 1)"
        }
        return nil
    }
    
    
    

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
