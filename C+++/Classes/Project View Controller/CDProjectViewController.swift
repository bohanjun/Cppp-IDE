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
    var isFileSaved: Bool = false
    
    @IBOutlet var tableView: CDProjectTableView!
    @IBOutlet weak var textField: NSTextField!
    
    @IBAction func set(_ sender: Any?) {
        
        didChange()
        if let file = self.representedObject as? CpppProject {
            file.compileCommand = textField.stringValue
        } else {
            saveProject(self)
        }
        
    }
    
    @IBAction func saveProject(_ sender: Any?) {
      //  if self.isFileSaved {
        self.view.window?.isDocumentEdited = false
        NSDocumentController.shared.currentDocument?.save(self)
      /*  } else {
            let panel = NSSavePanel()
            panel.allowedFileTypes = ["cpppproj"]
            panel.beginSheetModal(for: self.view.window!) { response in
                switch response {
                    case .OK:
                        do {
                            self.isFileSaved = true
                            let document = try CpppProject(type: "cpppproj")
                            document.fileURL = panel.url
                            document.allFiles = self.tableView.getAllTitles()
                            document.compileCommand = self.textField.stringValue
                            try document.write(to: panel.url!, ofType: "cpppproj")
                            self.representedObject = document
                            FileManager.default.createFile(atPath: panel.url!.path, contents: document.content.contentString.data(using: .utf8))
                            NSDocumentController.shared.addDocument(document)
                            self.showAlert("Warning", "The Project File is saved successfully. Now please reopen it. You shouldn't do anything before the reopenning operation because these channges will not be saved.")
                        } catch {
                            self.isFileSaved = false
                        }
                    
                    default: break
                }
            }
        }*/
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
            self.didChange()
            
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
                    self.didChange()
                default: break
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isFileSaved = false
        
    }
    
    override var representedObject: Any? {
        didSet {
            for i in children {
                i.representedObject = self.representedObject
            }
        }
    }
    
    weak var document: CpppProject? {
        if let docRepresentedObject = representedObject as? CpppProject {
            return docRepresentedObject
        }
        return nil
    }
    
    func didChange() {
        
        self.view.window?.isDocumentEdited = true
        
    }
    
    
}
