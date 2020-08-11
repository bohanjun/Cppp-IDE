//
//  CpppProject.swift
//  C+++
//
//  Created by 23786 on 2020/5/11.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

class CDProjectDocument: NSDocument {
    
    var project: CDProject!
    var contentViewController: CDProjectMainViewController!
    var documents = [NSDocument]()
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    
    override init() {
        super.init()
        // Add your subclass-specific initialization here.
        encoder.outputFormatting = .prettyPrinted
        self.project = CDProject(compileCommand: "Not set", version: "1.0")
        project.children.append(.document(CDProject.Document(path: "/Users/Apple/Desktop/main.cpp")))
        Swift.print(self.project.children)
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
        
        let storyboard = NSStoryboard(name: "Project", bundle: nil)
        if let windowController = storyboard.instantiateController(withIdentifier: "Project Window Controller") as? NSWindowController {
            self.addWindowController(windowController)
        }
        
        if let vc = storyboard.instantiateController(withIdentifier: "Project View Controller") as? CDProjectMainViewController {
            // sidebar.delegate = self.contentViewController
            vc.document = self
            self.contentViewController = vc
        }
        

    }
    
    
    
    // MARK: - Reading and Writing
    
    override func read(from data: Data, ofType typeName: String) throws {
        
        let result = try decoder.decode(CDProject.self, from: data)
        self.project = result
        
    }
    
    override func data(ofType typeName: String) throws -> Data {
        
        return try encoder.encode(self.project)
        
    }
    
}
