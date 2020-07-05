//
//  CDSnippetTableViewCell.swift
//  C+++
//
//  Created by 23786 on 2020/5/7.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

class CDSnippetTableViewCell: NSView, CDSnippetPopoverViewControllerDelegate {
    
    var index: Int!
    
    var explicitHeight: CGFloat = 45.0 {
        didSet {
            self.setup(width: 210.0)
        }
    }
    
    var displaysImage: Bool = true {
        didSet {
            self.setup(width: 210.0)
        }
    }
    
    var action: Selector = #selector(showSnippetInfo)
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        NSColor.textBackgroundColor.set()
        self.bounds.fill()
    }
    
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
        
        super.init(frame: NSRect(x: 0, y: 0, width: width, height: explicitHeight))
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
        
        for view in self.subviews {
            view.removeFromSuperview()
        }
        
        self.titleLabel = NSButton(frame: CGRect(x: 0, y: 0, width: width, height: explicitHeight))
        self.frame = CGRect(x: 0, y: 0, width: width, height: explicitHeight)
        self.titleLabel.action = self.action
        self.titleLabel.font = NSFont.systemFont(ofSize: 15.0)
        self.titleLabel.isBordered = true
        self.titleLabel.target = self
        self.titleLabel.title = "  " + self.title
        self.titleLabel.bezelStyle = .smallSquare
        self.titleLabel.imagePosition = .imageLeft
        self.titleLabel.imageScaling = .scaleProportionallyUpOrDown
        self.titleLabel.alignment = .left
        if self.displaysImage {
            self.titleLabel.image = image
        }
        self.addSubview(titleLabel)
        
    }
    
    @objc func didSetColor(image: NSImage) {
        
        self.titleLabel.image = image
        
    }
    
    @objc func showSnippetInfo() {
        
        popover = NSPopover()
        let vc = CDSnippetPopoperViewController()
        vc.setup(title: self.title, image: self.titleLabel.image, code: self.code, mode: false)
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
