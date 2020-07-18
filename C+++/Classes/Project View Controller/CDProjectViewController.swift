//
//  CDProjectViewController.swift
//  C+++
//
//  Created by 23786 on 2020/5/12.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

class CDProjectViewController: NSViewController {
    
    var filePaths = [String]()
    
    @IBOutlet var tableView: CDProjectTableView!
    @IBOutlet weak var textField: NSTextField!
    
    @IBAction func set(_ sender: Any?) {
        
        if let file = self.representedObject as? CDProjectDocument {
            file.compileCommand = textField.stringValue
        } else {
            saveProject(self)
        }
        
    }
    
    @IBAction func saveProject(_ sender: Any?) {
        self.view.window?.isDocumentEdited = false
        self.document?.save(self)
    }
    
    
    @IBAction func addFile(_ sender: Any?) {
        
        let dialog = NSOpenPanel()
        dialog.canChooseFiles = true
        dialog.canChooseDirectories = false
        dialog.allowsMultipleSelection = false
        dialog.title = "Add an exsisting file to the project"
        dialog.beginSheetModal(for: self.view.window!) { response in
            switch response {
                case .OK:
                    self.tableView.append(cell: CDProjectTableViewCell(path: dialog.url!.path))
                    (self.representedObject as! CDProjectDocument).allFiles = self.tableView.allItemTitles()
                default: break
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override var representedObject: Any? {
        didSet {
            for i in children {
                i.representedObject = self.representedObject
            }
        }
    }
    
    weak var document: CDProjectDocument? {
        if let docRepresentedObject = representedObject as? CDProjectDocument {
            return docRepresentedObject
        }
        return nil
    }
    
    
}
