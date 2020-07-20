//
//  C+++Document.swift
//  C+++
//
//  Created by 23786 on 2020/7/16.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

class CDGraphicalCodeDocument: NSDocument {
    
    @objc var content = CDDocumentContent(contentString: "")
    var contentViewController: CDGraphicalCodeEditorViewController!
    static let lineSeparator = "____CPPPGRAPHICALCODEDOCUMENTLINE____"
    
    override init() {
        super.init()
        // Add your subclass-specific initialization here.
        self.content.contentString = "\(CDGraphicalCodeDocument.lineSeparator)\nInclude\n<KEY=INCLUDEORIMPORT>#include</KEY=INCLUDEORIMPORT>\n<KEY=FILENAME></KEY=FILENAME>\n"
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
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Graphical Code Editor"), bundle: nil)
        if let windowController =
            storyboard.instantiateController(
                withIdentifier: NSStoryboard.SceneIdentifier("Graphical Window Controller")) as? CDGraphicalCodeEditorWindowController {
            
            addWindowController(windowController)
            
        }
        
        if let viewController =
            storyboard.instantiateController(
                withIdentifier: NSStoryboard.SceneIdentifier("Graphical View Controller")) as? CDGraphicalCodeEditorViewController {
            
            viewController.representedObject = self
            self.contentViewController = viewController
            
        }
        
    }
    
    
    // MARK: - Reading and Writing
    
    override func read(from data: Data, ofType typeName: String) throws {
        content.read(from: data)
    }
    
    override func data(ofType typeName: String) throws -> Data {
        return content.data()!
    }
    
    var numberOfRows: Int {
        return content.contentString.components(separatedBy: CDGraphicalCodeDocument.lineSeparator).count
    }
    
    var lines: [String] {
        return content.contentString.components(separatedBy: CDGraphicalCodeDocument.lineSeparator + "\n")
    }
    
}
