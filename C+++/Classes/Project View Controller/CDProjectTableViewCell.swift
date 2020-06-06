//
//  CDProjectTableViewCell.swift
//  C+++
//
//  Created by 23786 on 2020/5/12.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

class CDProjectTableViewCell: CDSnippetTableViewCell {
    
    var path: String
    
    init(path: String) {
        
        self.path = path
        super.init(title: path, image: NSImage(named: "Code"), code: "", width: 10000.0)
        
    }
    
    required convenience init?(coder: NSCoder) {
        self.init(path: "")
    }
    
    override func showInfo() {
        NSDocumentController.shared.openDocument(withContentsOf: URL(fileURLWithPath: self.title), display: true) { (document, opened, error) in
            if let doc = document as? CDCodeDocument {
                (doc.contentViewController.view.window?.windowController as? CDMainWindowController)?.toggleCompileInfoViewShown(self)
                (doc.contentViewController.view.window?.windowController as? CDMainWindowController)?.toggleCompileViewShown(self)
            } else {
                CDFileCompiler.shell("open \"\(self.title!)\"")
            }
        }
    }
    
}
