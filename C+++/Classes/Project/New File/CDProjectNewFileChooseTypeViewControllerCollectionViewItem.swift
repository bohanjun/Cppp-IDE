//
//  CDProjectNewFileChooseTypeViewControllerCollectionViewItem.swift
//  C+++
//
//  Created by 23786 on 2020/8/16.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

class CDProjectNewFileChooseTypeViewControllerCollectionViewItem: NSCollectionViewItem {
    
    override func loadView() {
        super.loadView()
        self.view.wantsLayer = true
        self.view.layer?.masksToBounds = true
        self.view.layer?.cornerRadius = 15.0
    }
    
    override var isSelected: Bool {
        didSet {
            self.view.layer?.backgroundColor = isSelected ? NSColor.selectedControlColor.cgColor : NSColor.clear.cgColor
        }
    }
    
    func setType(typeName: String, typeExtension: String) {
        self.imageView?.image = NSWorkspace.shared.icon(forFileType: typeExtension)
        self.textField?.stringValue = typeName
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}
