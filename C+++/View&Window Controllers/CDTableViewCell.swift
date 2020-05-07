//
//  CDTableViewCell.swift
//  C+++
//
//  Created by 23786 on 2020/5/7.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

class CDTableViewCell: NSView, CDTableViewCellInfoViewControllerDelegate {
    
    private let width: CGFloat = 201.0
    
    var title: String!
    var code: String!
    
    var titleLabel: NSButton!
    var popover: NSPopover!
    
    init(title: String, code: String) {
        
        super.init(frame: NSRect(x: 0, y: 0, width: width, height: 45))
        self.title = title
        self.code = code
        
        setup()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.title = ""
        self.code = ""
    }
    
    private func setup() {
        
        self.titleLabel = NSButton(frame: CGRect(x: 0, y: 0, width: width, height: 45))
        self.titleLabel.action = #selector(showInfo)
        self.titleLabel.font = NSFont.systemFont(ofSize: 15.0)
        self.titleLabel.isBordered = true
        self.titleLabel.target = self
        self.titleLabel.title = "  " + self.title
        self.titleLabel.bezelStyle = .shadowlessSquare
        self.titleLabel.imagePosition = .imageLeft
        self.titleLabel.imageScaling = .scaleNone
        self.titleLabel.alignment = .left
        self.titleLabel.image = NSImage(named: "Code")
        self.addSubview(titleLabel)
        
    }
    
    @objc func showInfo() {
        
        popover = NSPopover()
        let vc = CDTableViewCellInfoViewController()
        vc.setup(title: self.title, code: self.code)
        vc.delegate = (self.superview) as! CDTableView
        vc.closeDelegate = self
        if #available(OSX 10.14, *) {
            vc.view.appearance = darkAqua
            vc.textView.highlightr?.setTheme(to: "Agate")
        } else {
            vc.view.appearance = aqua
            vc.textView.highlightr?.setTheme(to: "Xcode")
        }
        vc.textView.didChangeText()
        vc.addToCodeDelegate = (((self.superview) as! CDTableView).superview?.superview?.window?.contentViewController) as! ViewController
        popover.contentViewController = vc
        popover.behavior = .transient
        popover.show(relativeTo: self.frame, of: self, preferredEdge: NSRectEdge.maxX)
        
    }
    
    @objc func willClose() {
        
        self.popover.close()
        
    }
    
}
