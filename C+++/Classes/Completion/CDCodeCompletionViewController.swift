//
//  CDCodeCompletionViewController.swift
//  C+++
//
//  Created by 23786 on 2020/6/28.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

class CDCodeCompletionViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    
    var results: [CDCompletionResult]!
    var popover: NSPopover!
    @IBOutlet weak var tableView: NSTableView!
    var delegate: CDCodeCompletionViewControllerDelegate!
    var range: NSRange!
    
    
    // MARK: NSTableViewDataSource
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: NSTableView, didClick tableColumn: NSTableColumn) {
        
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        
        if results.count >= row {
            return results[row].textForDisplay
        } else {
            return nil
        }
        
        
        /*if results != nil {
            if let _result = results[row] as? CKCompletionResult {
                for chunk in _result.chunks {
                    if let _chunk = chunk as? CKCompletionChunk {
                        if _chunk.kind == CKCompletionChunkKindTypedText {
                            return _chunk.text!
                        } else {
                            return nil
                        }
                    } else {
                        return nil
                    }
                }
            }
        } else {
            return nil
        }
        return nil*/
        
    }
    
    // var results = [String]()
    
    deinit {
        
        tableView.delegate = nil
        tableView.dataSource = nil
        if self.popover.isShown == true {
            popover.close()
        }
        
    }
    
    override func awakeFromNib() {
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.tableView?.selectRowIndexes(IndexSet(integer: 0), byExtendingSelection: false)
    }
    
    func closePopover() {
        popover?.close()
    }
    
    func openInPopover(relativeTo rect: NSRect, of view: NSView, preferredEdge edge: NSRectEdge) {
        
        if popover == nil {
            
            popover = NSPopover()
            popover.animates = false
            popover.behavior = .transient
            popover.contentViewController = self
            popover.show(relativeTo: rect, of: view, preferredEdge: edge)
            
        }
        
    }
    
    override func keyDown(with event: NSEvent) {
        
        if event.specialKey == NSEvent.SpecialKey(rawValue: 13) && self.tableView.selectedRow != -1 {
            
            self.delegate?.codeCompletionViewController(self, didSelectItemWithTitle: self.results[self.tableView.selectedRow].completionString, range: self.range)
            self.closePopover()
            return
            
        }
        
        self.closePopover()
        NSApplication.shared.sendEvent(event)
        
    }
    
}
