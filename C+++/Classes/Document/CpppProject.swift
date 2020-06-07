//
//  CpppProject.swift
//  C+++
//
//  Created by 23786 on 2020/5/11.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa


extension NSDocumentController {
    
    @IBAction func newProject(_ sender: Any?) {
        
        do {
            (NSDocumentController.shared as! CDDocumentController).isCreatingProject = true
            try NSDocumentController.shared.openUntitledDocumentAndDisplay(true)
            (NSDocumentController.shared as! CDDocumentController).isCreatingProject = false
        } catch {
            print("Error")
        }
        
    }
    
}




class CpppProject: NSDocument {
    
    @objc var content = CDDocumentContent(contentString: "")
    var contentViewController: CDProjectViewController!
    
    override init() {
        super.init()
        // Add your subclass-specific initialization here.
    }
    
    override func defaultDraftName() -> String {
        return "Untitled C+++ Project"
    }
    
    
    // MARK: - Enablers
    
    // This enables auto save.
    override class var autosavesInPlace: Bool {
        return true
    }
    
    // This enables asynchronous-writing.
    override func canAsynchronouslyWrite(to url: URL, ofType typeName: String, for saveOperation: NSDocument.SaveOperationType) -> Bool {
        return true
    }
    
    // This enables asynchronous reading.
    override class func canConcurrentlyReadDocuments(ofType: String) -> Bool {
        return ofType == "public.plain-text"
    }
    
    
    
    // MARK: - User Interface
    
    override func makeWindowControllers() {
        
        launchViewController.view.window?.close()
        
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        if let windowController =
            storyboard.instantiateController(
                withIdentifier: NSStoryboard.SceneIdentifier("Project Window Controller")) as? NSWindowController {
            
            self.addWindowController(windowController)
            
            // Set the view controller's represented object as your document.
            if let contentVC = windowController.contentViewController as? CDProjectViewController {
                
                contentVC.filePaths = self.allFiles
                contentVC.representedObject = self

                contentVC.tableView.paths = contentVC.filePaths
                contentVC.tableView.cells = contentVC.tableView.load()
                contentVC.isFileSaved = true
                contentVC.tableView.setup()
                contentVC.textField.stringValue = self.compileCommand
                
                contentViewController = contentVC
                
            }
        }
    }
    
    @objc dynamic var compileCommand: String {
        
        get {
            let string = self.content.contentString
            let lines = string.components(separatedBy: "\n")
            return lines.first ?? ""
        }
        
        set {
            let string = newValue + "\n" + allFiles.joined(separator: "\n")
            self.content.contentString = string
        }
        
    }
    
    @objc dynamic var allFiles: [String] {
        
        get {
            let string = self.content.contentString
            var lines = string.components(separatedBy: "\n")
            lines.removeFirst()
            return lines
        }
        
        set {
            let string = compileCommand + "\n" + newValue.joined(separator: "\n")
            self.content.contentString = string
        }
        
    }
    
    
    // MARK: - Reading and Writing
    
    override func read(from data: Data, ofType typeName: String) throws {
        
        content.read(from: data)
        
    }
    
    override func data(ofType typeName: String) throws -> Data {
        
        return content.data()!
        
    }
    
    
    // MARK: - Printing
    
    func thePrintInfo() -> NSPrintInfo {
        let thePrintInfo = NSPrintInfo()
        thePrintInfo.horizontalPagination = .fit
        thePrintInfo.isHorizontallyCentered = false
        thePrintInfo.isVerticallyCentered = false
        
        // One inch margin all the way around.
        thePrintInfo.leftMargin = 72.0
        thePrintInfo.rightMargin = 72.0
        thePrintInfo.topMargin = 72.0
        thePrintInfo.bottomMargin = 72.0
        
        printInfo.dictionary().setObject(NSNumber(value: true),
                                         forKey: NSPrintInfo.AttributeKey.headerAndFooter as NSCopying)
        
        return thePrintInfo
    }
    
    @objc
    func printOperationDidRun(
        _ printOperation: NSPrintOperation, success: Bool, contextInfo: UnsafeMutableRawPointer?) {
        // Printing finished...
    }
    
    @IBAction override func printDocument(_ sender: Any?) {
        // Print the NSTextView.
        
        // Create a copy to manipulate for printing.
        let pageSize = NSSize(width: (printInfo.paperSize.width), height: (printInfo.paperSize.height))
        let textView = NSTextView(frame: NSRect(x: 0.0, y: 0.0, width: pageSize.width, height: pageSize.height))
        
        // Make sure we print on a white background.
        textView.appearance = NSAppearance(named: .aqua)
        
        // Copy the attributed string.
        textView.textStorage?.append(NSAttributedString(string: "This C+++ Project document cannot be printed."))
        
        let printOperation = NSPrintOperation(view: textView)
        printOperation.runModal(
            for: windowControllers[0].window!,
            delegate: self,
            didRun: #selector(printOperationDidRun(_:success:contextInfo:)), contextInfo: nil)
        
    }
    
    
    @IBAction func compileProject(_ sender: Any?) {
        
        self.save(self)
        var res = CDFileCompiler.shell(self.compileCommand).last
        if res == "" {
            res = "Compile Succeed"
        }
        self.contentViewController.showAlert("Compile Result", res!)
        
    }
    
    @IBAction func debugFile(_ sender: Any?) {
        
        self.contentViewController.presentAsSheet(CDFileCompiler.debugFile(fileURL: self.fileURL?.path ?? ""))
        
    }
    
}
