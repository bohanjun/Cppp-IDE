//
//  CDProjectTableViewCell.swift
//  C+++
//
//  Created by 23786 on 2020/5/12.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

class CDProjectTableViewCell: CDTableViewCell {
    
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
            if let doc = document as? Document {
                doc.contentViewController.right = false
                doc.contentViewController.RightConstraint.constant = 0.0
                doc.contentViewController.bottom = false
                doc.contentViewController.BottomConstraint.constant = 0.0
            }
        }
        return
    }
    
}
