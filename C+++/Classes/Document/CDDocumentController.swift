//
//  CDDocumentController.swift
//  C+++
//
//  Created by 23786 on 2020/5/31.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa


extension NSDocumentController {
    
    @IBAction func newProject(_ sender: Any?) {
        
        (NSDocumentController.shared as! CDDocumentController)._defaultType = "C+++ Project"
        self.newDocument(sender)
        (NSDocumentController.shared as! CDDocumentController)._defaultType = "C++ Source"
        
    }
    
    /*
    @IBAction func newGraphicalCodeDocument(_ sender: Any?) {
        
        do {
            (NSDocumentController.shared as! CDDocumentController)._defaultType = "C+++ Graphical Code File"
            try NSDocumentController.shared.openUntitledDocumentAndDisplay(true)
            (NSDocumentController.shared as! CDDocumentController)._defaultType = "C++ Source"
        } catch {
            print("Error")
        }
        
    }*/
    
}



class CDDocumentController: NSDocumentController {
    
    var _defaultType: String = "C++ Source"
    
    override var defaultType: String? {
        return _defaultType
    }
    
    override func newDocument(_ sender: Any?) {
        super.newDocument(sender)
        
        self.currentDocument?.save(self)
        if let document = self.currentDocument as? CDCodeDocument {
            document.contentViewController.mainTextView.document = document
            return
        }
        if let document = self.currentDocument as? CDProjectDocument {
            if document.fileURL == nil {
                // document.close()
                // return
            } else {
                FileManager.default.createFile(atPath: document.fileURL!.deletingLastPathComponent().appendingPathComponent("main.cpp").path, contents: "#include <cstdio>\nint main() {\n\treturn 0;\n}\n".data(using: .utf8), attributes: nil)
            }
        }
    }
    
}
