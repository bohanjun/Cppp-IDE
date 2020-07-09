//
//  CDDiagnosticsViewController.swift
//  C+++
//
//  Created by 23786 on 2020/7/3.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

protocol CDDiagnosticsViewControllerDelegate {
    
    func diagnosticsViewController(_ vc: CDDiagnosticsViewController, shouldReplaceRange range: NSRange, with string: String)
    func stringInRange(range: NSRange) -> String
    
}


class CDDiagnosticsViewController: NSViewController, NSTableViewDataSource {
    
    var popover: NSPopover!
    var diagnostic: CKDiagnostic!
    var delegate: CDDiagnosticsViewControllerDelegate!
    var fixIts = [CKFixIt]()
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var titleLabel: NSTextField!
    @IBOutlet weak var tryToFixItLabel: NSTextField!
    
    @IBAction func fixIt(_ sender: Any?) {
        
        let fixIt = fixIts[self.tableView.selectedRow]
        self.delegate?.diagnosticsViewController(self, shouldReplaceRange: fixIt.range, with: fixIt.string ?? "")
        self.popover?.close()
        
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        
        if tableColumn?.title == "Message" {
            return "Replace \"\(self.delegate.stringInRange(range:  self.fixIts[row].range))\" with \"\(self.fixIts[row].string!)\""
        } else {
            return nil
        }
        
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        
        return self.fixIts.count
        
    }
    
    func openInPopover(relativeTo rect: NSRect, of view: NSView, preferredEdge edge: NSRectEdge, diagnostic: CKDiagnostic) {
        
        self.diagnostic = diagnostic
        
        for _fixIt in self.diagnostic.fixIts {
            if let fixIt = _fixIt as? CKFixIt {
                self.fixIts.append(fixIt)
            }
        }
        
        if popover == nil {
            
            popover = NSPopover()
            popover.behavior = .transient
            popover.contentViewController = self
            popover.show(relativeTo: rect, of: view, preferredEdge: edge)
            
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.titleLabel.stringValue = self.diagnostic.description
        if self.fixIts.count == 0 {
            self.tryToFixItLabel.isHidden = true
            self.tableView.enclosingScrollView?.isHidden = true
        }
        
    }
   
    
}
