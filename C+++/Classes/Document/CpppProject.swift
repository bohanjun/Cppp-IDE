//
//  CpppProject.swift
//  C+++
//
//  Created by 23786 on 2020/5/11.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

class CpppProject: NSDocument {
    
    @objc var content = Content(contentString: "")
    var contentViewController: ViewController!
    
    override init() {
        super.init()
        // Add your subclass-specific initialization here.
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
    
    /// - Tag: makeWindowControllersExample
    override func makeWindowControllers() {
        // Returns the storyboard that contains your document window.
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        if let windowController =
            storyboard.instantiateController(
                withIdentifier: NSStoryboard.SceneIdentifier("Document Window Controller")) as? NSWindowController {
            
            self.addWindowController(windowController)
            
            // Set the view controller's represented object as your document.
            if let contentVC = windowController.contentViewController as? ViewController {
                
                contentVC.representedObject = self.content
                contentVC.filePaths = self.allFilePaths()
                contentViewController = contentVC
                contentVC.TextView.didChangeText()
                
            }
        }
    }
    
    func allFilePaths() -> [String] {
        
        let string = self.content.contentString
        var lines = string.components(separatedBy: "\n")
        lines.removeFirst()
        return lines
        
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
        textView.textStorage?.append(NSAttributedString(string: content.contentString))
        
        let printOperation = NSPrintOperation(view: textView)
        printOperation.runModal(
            for: windowControllers[0].window!,
            delegate: self,
            didRun: #selector(printOperationDidRun(_:success:contextInfo:)), contextInfo: nil)
        
    }
    
    /*
    @IBAction func compileFile(_ sender: Any?) {
        
        if self.isDraft {
            self.contentViewController.showAlert("You haven't saved the file yet. Please save it and then compile it.", "File not saved")
            return
        }
        self.save(self)
        let res = CDFileCompiler.CompileSource(fileURL: self.fileURL?.path ?? "")
        self.contentViewController.CompileInfo.string = res
        
    }
    
    @IBAction func debugFile(_ sender: Any?) {
        
        self.contentViewController.presentAsSheet(CDFileCompiler.debugFile(fileURL: self.fileURL?.path ?? ""))
        
    }
    
    @IBAction func compileWithoutRunning(_ sender: Any?) {
        
        if self.isDraft {
            self.contentViewController.showAlert("You haven't saved the file yet. Please save it and then compile it.", "File not saved")
            return
        }
        self.save(self)
        let res = CDFileCompiler.CompileWithoutRunning(fileURL: self.fileURL?.path ?? "")
        self.contentViewController.CompileInfo.string = res
        
    }*/
    
}
