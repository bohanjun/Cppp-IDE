//
//  CDProjectMainViewController+NSOutlineView.swift
//  C+++
//
//  Created by 23786 on 2020/8/11.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

extension CDProjectMainViewController: NSOutlineViewDataSource, NSOutlineViewDelegate {
    
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
            return CDProjectItem.project(self.document?.project ?? CDProject())
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
        return 1
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
    
    
    
    @IBAction func addExsistingFile(_ sender: Any?) {
        
        let panel = NSOpenPanel()
        let result = panel.runModal()
        if result == .OK {
            
            let newItem: CDProjectItem = .document(CDProject.Document(path: panel.url!.path))
            
            let _item = self.outlineView.item(atRow: self.outlineView.selectedRow)
            
            if let item = _item as? CDProjectItem {
                
                switch item {
                    
                    case .document(_):
                        if let superItem = self.outlineView.parent(forItem: _item) as? CDProjectItem {
                            switch superItem {
                                case .folder(let folder): folder.children.append(newItem)
                                case .project(let project): project.children.append(newItem)
                                default: break
                            }
                        }
                        
                    case .folder(let folder):
                        folder.children.append(newItem)
                        
                    case .project(let project):
                        project.children.append(newItem)
                        
                }
            }
            
            self.outlineView.reloadItem(nil, reloadChildren: true)
            
        }
        
    }
    
    @IBAction func addFolder(_ sender: Any?) {
        
        let newItem: CDProjectItem = .folder(CDProject.Folder(name: "Folder"))
        
        let _item = self.outlineView.item(atRow: self.outlineView.selectedRow)
        
        if let item = _item as? CDProjectItem {
            
            switch item {
                
                case .document(_):
                    if let superItem = self.outlineView.parent(forItem: _item) as? CDProjectItem {
                        switch superItem {
                            case .folder(let folder): folder.children.append(newItem)
                            case .project(let project): project.children.append(newItem)
                            default: break
                        }
                    }
                    
                case .folder(let folder):
                    folder.children.append(newItem)
                    
                case .project(let project):
                    project.children.append(newItem)
                    
            }
        }
        
        self.outlineView.reloadItem(nil, reloadChildren: true)
        
    }
    
    @IBAction func didClick(_ sender: NSOutlineView) {
        
        let item = sender.item(atRow: sender.clickedRow)
        if let item = item as? CDProjectItem {
            self.document.openDocument(item: item)
        }
        
    }
    
    @IBAction func removeSelected(_ sender: Any?) {
        
        let _item = self.outlineView.item(atRow: self.outlineView.selectedRow)
        
        if _item == nil {
            return
        }
        
        if let superItem = self.outlineView.parent(forItem: _item) as? CDProjectItem {
            
            let childIndex = self.outlineView.childIndex(forItem: _item!)
            
            switch superItem {
                case .document(let a): a.children.remove(at: childIndex)
                case .project(let a): a.children.remove(at: childIndex)
                case .folder(let a): a.children.remove(at: childIndex)
            }
            
            self.outlineView.removeItems(at: IndexSet(arrayLiteral: childIndex), inParent: superItem)
            
            // self.outlineView.reloadItem(nil, reloadChildren: true)
            
        }
        
    }
    
    @IBAction func showSelectedDocumentInFinder(_ sender: Any?) {
        
        let _item = self.outlineView.item(atRow: self.outlineView.selectedRow)
        if let item = _item as? CDProjectItem {
            switch item {
                case .document(let document):
                    NSWorkspace.shared.selectFile(document.path, inFileViewerRootedAtPath: "")
                case .project(_):
                    NSWorkspace.shared.selectFile(self.document?.fileURL?.path ?? "", inFileViewerRootedAtPath: "")
                default:
                    break
            }
        }
        
    }

}
