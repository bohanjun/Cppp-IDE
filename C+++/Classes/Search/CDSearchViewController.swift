//
//  CDSearchViewController.swift
//  C+++
//
//  Created by 23786 on 2020/7/25.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

class CDSearchViewController: NSViewController, NSTableViewDataSource, NSTextFieldDelegate, NSTableViewDelegate {
    
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var detailView: NSView!
    @IBOutlet weak var textField: NSTextField!
    
    var popover: NSPopover!
    
    var allResults = [CDSearchResult]()
    var filteredResults = [CDSearchResult]()
    
    func controlTextDidChange(_ obj: Notification) {
        self.filteredResults = []
        for i in self.allResults {
            if i.title.contains(self.textField.stringValue) {
                print(true)
                self.filteredResults.append(i)
            }
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        if tableColumn?.title == "Title" {
            return self.filteredResults[row].title
        } else {
            return self.filteredResults[row].image
        }
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.filteredResults.count
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        for view in self.detailView.subviews {
            view.removeFromSuperview()
        }
        if self.tableView.selectedRowIndexes.count != 0 {
            self.filteredResults[self.tableView.selectedRow].loadResultDetailInView(view: self.detailView)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func openInPopover(relativeTo rect: NSRect, of view: NSView, preferredEdge edge: NSRectEdge) {
        
        if popover == nil {
            
            popover = NSPopover()
            popover.behavior = .transient
            popover.contentViewController = self
            popover.show(relativeTo: rect, of: view, preferredEdge: edge)
            
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        for snippet in CDSnippetTableView.savedSnippets {
            self.allResults.append(CDSearchResult(snippet: snippet))
        }
        for url in NSDocumentController.shared.recentDocumentURLs {
            self.allResults.append(CDSearchResult(recentFileUrl: url))
        }
        self.filteredResults = self.allResults
        self.tableView?.reloadData()
        
    }
    
}
