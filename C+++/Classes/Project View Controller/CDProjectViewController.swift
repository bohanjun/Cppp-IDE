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
        
        self.view.window?.isDocumentEdited = true
        (self.representedObject as! CpppProject).compileCommand = textField.stringValue
        
    }
    
    @IBAction func saveProject(_ sender: Any?) {
        self.view.window?.isDocumentEdited = false
        NSDocumentController.shared.currentDocument?.save(self)
    }
    
    
    @IBOutlet weak var RemoveIndexTextField: NSTextField!
    
    @IBAction func Remove(_ sender: NSButton) {
        if let index = Int(self.RemoveIndexTextField.stringValue) {
            if index - 1 >= self.tableView.cells.count || index <= 0 {
                self.showAlert("Warning", "File index invalid.")
                return
            }
            self.tableView.remove(at: index - 1)
            self.RemoveIndexTextField.stringValue = ""
            (self.representedObject as! CpppProject).allFiles = self.tableView.getAllTitles()
            self.view.window?.isDocumentEdited = true
        } else {
            self.showAlert("Warning", "Please type the index of the document in the text box and then try to remove it from the project.")
        }
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
                    (self.representedObject as! CpppProject).allFiles = self.tableView.getAllTitles()
                    self.view.window?.isDocumentEdited = true
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
    
}
