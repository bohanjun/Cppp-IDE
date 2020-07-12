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
        super.init(title: (path as NSString).lastPathComponent, image: NSWorkspace.shared.icon(forFile: self.path), code: "", width: 10000.0)
        
        self.menu?.removeAllItems()
        self.menu?.addItem(NSMenuItem(title: "Open", action: #selector(didClickCell), keyEquivalent: ""))
        self.menu?.addItem(NSMenuItem(title: "Show In Finder", action: #selector(showInFinder), keyEquivalent: ""))
        self.menu?.addItem(NSMenuItem(title: "Move Up", action: #selector(_moveUp), keyEquivalent: ""))
        self.menu?.addItem(NSMenuItem(title: "Move Down", action: #selector(_moveDown), keyEquivalent: ""))
        self.menu?.addItem(NSMenuItem(title: "Remove File", action: #selector(delete), keyEquivalent: ""))
        
    }
    
    required convenience init?(coder: NSCoder) {
        self.init(path: "")
    }
    
    override func didClickCell() {
        NSWorkspace.shared.open(URL(fileURLWithPath: self.path))
    }
    
    @objc func showInFinder() {
        NSWorkspace.shared.selectFile(self.path, inFileViewerRootedAtPath: "")
    }
    
}
