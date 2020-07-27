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
        
        do {
            (NSDocumentController.shared as! CDDocumentController)._defaultType = "C+++ Project"
            try NSDocumentController.shared.openUntitledDocumentAndDisplay(true)
            (NSDocumentController.shared as! CDDocumentController)._defaultType = "C++ Source"
        } catch {
            print("Error")
        }
        
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
        }
    }
    
}
