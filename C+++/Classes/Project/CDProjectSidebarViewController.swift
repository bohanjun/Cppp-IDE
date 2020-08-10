//
//  CDProjectSidebarViewController.swift
//  C+++
//
//  Created by 23786 on 2020/8/10.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

class CDProjectSidebarViewController: NSViewController, NSOutlineViewDataSource, NSOutlineViewDelegate {
    
    @IBOutlet weak var outlineView: NSOutlineView!
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        if let item = item as? CDProjectItem {
            return item.hasChildren
        }
        return false
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        //print("self.project = \(self.project?.children)")
        if let projectItem = item as? CDProjectItem {
            if projectItem.hasChildren && projectItem.children.count > index {
                return projectItem.children[index]
            }
        }
        return self.document.project ?? CDProjectItem()
    }
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if let item = item as? CDProjectItem {
            return item.children.count
        }
        return self.document?.project?.children.count ?? 0
    }
    
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        var cell: NSTableCellView!
        if let item = item as? CDProjectItem {
            cell = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "Cell"), owner: self) as? NSTableCellView
            cell.textField?.stringValue = item.title
        }
        return cell
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        self.document = self.view.window?.windowController?.document as? CDProjectDocument
        self.outlineView.reloadData()
    }
    
    weak var document: CDProjectDocument!
    
}
