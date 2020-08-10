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
            switch item {
                case .document(let document): return document.hasChildren
                case .folder(let folder): return folder.hasChildren
                case .project(let project): return project.hasChildren
            }
        }
        return false
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        
        if item == nil {
            return CDProjectItem.project(self.document.project!)
        }
        
        if let projectItem = item as? CDProjectItem {
            var hasChildren = true
            var children = [CDProjectItem]()
            switch projectItem {
                case .document(let document):
                    hasChildren = document.hasChildren
                    children = document.children
                case .folder(let folder):
                    hasChildren = folder.hasChildren
                    children = folder.children
                case .project(let project):
                    hasChildren = project.hasChildren
                    children = project.children
            }
            if hasChildren && children.count > index {
                return children[index]
            }
        }
        fatalError()
        
    }
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if let item = item as? CDProjectItem {
            switch item {
                case .document(let document): return document.children.count
                case .folder(let folder): return folder.children.count
                case .project(let project): return project.children.count
            }
        }
        return self.document?.project?.children.count ?? 0
    }
    
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        var cell: NSTableCellView!
        if let item = item as? CDProjectItem {
            cell = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "Cell"), owner: self) as? NSTableCellView
            
            switch item {
                case .document(let item):
                    cell.textField?.stringValue = item.title
                    cell.imageView?.image = NSWorkspace.shared.icon(forFile: item.path)
                case .project(let item):
                    cell.textField?.stringValue = item.title
                    cell.imageView?.image = NSImage(named: NSImage.listViewTemplateName)
                case .folder(let item):
                    cell.textField?.stringValue = item.title
                    cell.imageView?.image = NSImage(named: NSImage.touchBarFolderTemplateName)
            }
            
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
    
    @IBAction func add(_ sender: Any?) {
        
        let panel = NSOpenPanel()
        let result = panel.runModal()
        if result == .OK {
            self.document.project.children.append(.document(CDProject.Document(path: panel.url!.path)))
            self.outlineView.reloadData()
        }
        
    }
    
}
