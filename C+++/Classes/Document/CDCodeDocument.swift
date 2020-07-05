//
//  Document.swift
//  C+++
//
//  Created by apple on 2020/3/23.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

class CDCodeDocument: NSDocument {
    
    @objc var content = CDDocumentContent(contentString: "")
    var contentViewController: CDMainViewController!
    
    override init() {
        super.init()
        // Add your subclass-specific initialization here.
    }
    
    override func defaultDraftName() -> String {
        return "Untitled Code Document"
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
        
        // Returns the storyboard that contains your document window.
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        if let windowController =
            storyboard.instantiateController(
                withIdentifier: NSStoryboard.SceneIdentifier("Document Window Controller")) as? CDMainWindowController {
            addWindowController(windowController)
            
            // Set the view controller's represented object as your document.
            if let contentVC = windowController.contentViewController as? CDMainViewController {
                
                contentVC.representedObject = content
                contentViewController = contentVC
                contentVC.mainTextView?.didChangeText()
                
                if self.fileType == "Input File" || self.fileType == "Output File" {
                    windowController.disableCompiling()
                }
                
            }
            
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
        textView.textStorage?.append(NSAttributedString(string: content.contentString))
        
        let printOperation = NSPrintOperation(view: textView)
        printOperation.runModal(
            for: windowControllers[0].window!,
            delegate: self,
            didRun: #selector(printOperationDidRun(_:success:contextInfo:)), contextInfo: nil)
        
    }
    
    @IBAction func compileFile(_ sender: Any?) {
        
        if self.fileURL == nil {
            self.contentViewController.showAlert("You haven't saved the file yet. Please save it before compiling it.", "")
            return
        }
        
        self.save(self)
        self.contentViewController.setStatus(string: "\(self.fileURL?.lastPathComponent ?? "C+++") | Compiling...")
        let res = CDFileCompiler.compileFile(fileURL: self.fileURL?.path ?? "").replacingOccurrences(of: self.fileURL!.path + ":", with: "")
        self.contentViewController.compileInfo.string = res
        self.contentViewController.setStatus(string: "\(self.fileURL?.lastPathComponent ?? "C+++") | Compile Finished")
        
        Swift.print(res)
        
        DispatchQueue.main.async {
            
            for i in res.components(separatedBy: "\n") {
                if i.first == nil {
                    continue
                }
                if i.first!.isNumber && i.contains(":") {
                    let index = i.firstIndexOf(":")
                    let nsstring = NSString(string: i)
                    let substring = nsstring.substring(to: index)
                    if let int = Int(substring) {
                        Swift.print(int)
                        self.contentViewController?.lineNumberTextView?.markLineNumber(line: int, color: .orange)
                    }
                }
            }
            
        }
        
    }
    
    @IBAction func debugFile(_ sender: Any?) {
        
        self.contentViewController.presentAsSheet(CDFileCompiler.debugFile(fileURL: self.fileURL?.path ?? ""))
        
    }
    
    @IBAction func testFile(_ sender: Any?) {
        
        let vc = CDTestViewController()
        vc.fileURL = self.fileURL?.path ?? ""
        self.contentViewController.presentAsSheet(vc)
        
    }
    
    @IBAction func compileWithoutRunning(_ sender: Any?) {
        
        if self.fileURL == nil {
            self.contentViewController.showAlert("You haven't saved the file yet. Please save it before compiling it.", "")
            return
        }
        
        self.save(self)
        self.contentViewController.setStatus(string: "\(self.fileURL?.lastPathComponent ?? "C+++") | Compiling...")
        let res = CDFileCompiler.compileFileWithoutRunning(fileURL: self.fileURL?.path ?? "")
        self.contentViewController.compileInfo.string = res
        self.contentViewController.setStatus(string: "\(self.fileURL?.lastPathComponent ?? "C+++") | Compile Finished")
        
        DispatchQueue.main.async {
            
            for i in res.components(separatedBy: "\n") {
                if i.first == nil {
                    continue
                }
                if i.first!.isNumber && i.contains(":") {
                    let index = i.firstIndexOf(":")
                    let nsstring = NSString(string: i)
                    let substring = nsstring.substring(to: index)
                    if let int = Int(substring) {
                        Swift.print(int)
                        self.contentViewController?.lineNumberTextView?.markLineNumber(line: int, color: .orange)
                    }
                }
            }
            
        }
        
    }
    
}
