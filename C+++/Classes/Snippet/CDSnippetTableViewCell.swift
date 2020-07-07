//
//  CDSnippetTableViewCell.swift
//  C+++
//
//  Created by 23786 on 2020/5/7.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

class CDSnippetTableViewCell: NSView, CDSnippetPopoverViewControllerDelegate {
    
    // MARK: - Properties
    
    var index: Int!
    var title: String!
    var code: String!
    var image: NSImage!
    var titleLabel: NSButton!
    private var popover: NSPopover!
    weak var snippetTableView: CDSnippetTableView!
    
    
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
    
    
    // MARK: - @objc Methods
    
    @objc func delete() {
        self.snippetTableView.removeItem(withTitle: self.title)
    }
    
    @objc func _moveUp() {
        self.snippetTableView.moveCellUp(cell: self)
    }
    
    @objc func _moveDown() {
        self.snippetTableView.moveCellDown(cell: self)
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
    
    
    
    override func encode(with coder: NSCoder) {
        
        coder.encode(title, forKey: "title")
        coder.encode(code, forKey: "code")
        coder.encode(image, forKey: "image")
        
    }
    
    
    // MARK: - Initializers
    
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
    
    
    
    // MARK: - setup(width: CGFloat)
    
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
        
        let menu = NSMenu(title: "Menu")
        menu.addItem(NSMenuItem(title: "Remove", action: #selector(delete), keyEquivalent: String()))
        if self.index != 0 { menu.addItem(NSMenuItem(title: "Move Up", action: #selector(_moveUp), keyEquivalent: String())) }
        if self.index != ((self.snippetTableView?.cells.count) ?? 0) - 1 { menu.addItem(NSMenuItem(title: "Move Down", action: #selector(_moveDown), keyEquivalent: String())) }
        self.menu = menu
        
        self.addSubview(titleLabel)
        
    }
}
