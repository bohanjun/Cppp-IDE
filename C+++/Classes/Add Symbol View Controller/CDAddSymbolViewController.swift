//
//  CDAddSymbolViewController.swift
//  C+++
//
//  Created by 23786 on 2020/7/3.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

protocol CDAddSymbolViewControllerDelegate {
    
    func viewController(_ viewController : CDAddSymbolViewController, addText text : String)
    
}

class CDAddSymbolViewController: NSViewController {
    
    @IBOutlet weak var textView: NSTextView!
    var popover: NSPopover!
    var delegate: CDAddSymbolViewControllerDelegate!
    
    @IBAction func add(_ sender: Any?) {
        
        self.delegate?.viewController(self, addText: self.textView.string)
        self.popover?.close()
        
    }
    
    func openInPopover(relativeTo rect: NSRect, of view: NSView, preferredEdge edge: NSRectEdge) {
        
        if popover == nil {
            
            popover = NSPopover()
            popover.behavior = .transient
            popover.contentViewController = self
            popover.show(relativeTo: rect, of: view, preferredEdge: edge)
            
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}
