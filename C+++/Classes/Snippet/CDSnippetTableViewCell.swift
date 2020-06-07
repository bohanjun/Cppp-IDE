//
//  CDTableViewCell.swift
//  C+++
//
//  Created by 23786 on 2020/5/7.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

class CDSnippetTableViewCell: NSView, CDSnippetPopoverViewControllerDelegate {
    
    var title: String!
    var code: String!
    var image: NSImage!
    
    var titleLabel: NSButton!
    var popover: NSPopover!
    
    override func encode(with coder: NSCoder) {
        
        coder.encode(title, forKey: "title")
        coder.encode(code, forKey: "code")
        coder.encode(image, forKey: "image")
        
    }
    
    init(title: String?, image: NSImage?, code: String?, width: CGFloat) {
        
        super.init(frame: NSRect(x: 0, y: 0, width: width, height: 45))
        self.title = title
        self.code = code
        self.image = image
        setup(width: width)
        
    }
    
    required convenience init?(coder: NSCoder) {
        
        let title = coder.decodeObject(forKey: "title") as? String
        let code = coder.decodeObject(forKey: "code") as? String
        let image = coder.decodeObject(forKey: "image") as? NSImage
        
        self.init(title: title, image: image, code: code, width: 210.0)
        
    }
    
    func setup(width: CGFloat) {
        
        self.titleLabel = NSButton(frame: CGRect(x: 0, y: 0, width: width, height: 45))
        self.titleLabel.action = #selector(showInfo)
        self.titleLabel.font = NSFont.systemFont(ofSize: 15.0)
        self.titleLabel.isBordered = true
        self.titleLabel.target = self
        self.titleLabel.title = "  " + self.title
        self.titleLabel.bezelStyle = .smallSquare
        self.titleLabel.imagePosition = .imageLeft
        self.titleLabel.imageScaling = .scaleNone
        self.titleLabel.alignment = .left
        self.titleLabel.image = image
        self.addSubview(titleLabel)
        
    }
    
    @objc func didSetColor(image: NSImage) {
        
        self.titleLabel.image = image
        
    }
    
    @objc func showInfo() {
        
        popover = NSPopover()
        let vc = CDSnippetPopoperViewController()
        vc.setup(title: self.title, image: self.titleLabel.image!, code: self.code, mode: false)
        vc.delegate = (self.superview) as! CDSnippetTableView
        vc.closeDelegate = self
        vc.addToCodeDelegate = (((self.superview) as! CDSnippetTableView).superview?.superview?.window?.contentViewController) as! CDMainViewController
        popover.contentViewController = vc
        popover.behavior = .transient
        popover.show(relativeTo: self.frame, of: self, preferredEdge: NSRectEdge.maxX)
        
    }
    
    @objc func willClose() {
        
        self.popover.close()
        
    }
    
}
