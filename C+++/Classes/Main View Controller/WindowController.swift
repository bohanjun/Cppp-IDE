//
//  WindowController.swift
//  Code Editor
//
//  Created by apple on 2020/3/23.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa



class WindowController: NSWindowController, NSWindowDelegate {
    
    @objc dynamic var statusString = "C+++ | Ready"
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        if #available(OSX 10.14, *) {
            self.window?.appearance = darkAqua
        } else {
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.shouldCascadeWindows = true
    }
    
    
    
    @IBAction func toggleCI(_ sender: Any) {
        let vc = (self.contentViewController as! CDMainViewController)
        if vc.bottom == true {
            vc.BottomConstraint.constant = 22.0
            vc.bottom = false
        } else {
            vc.BottomConstraint.constant = 165.0
            vc.bottom = true
        }
    }
    
    @IBAction func toggleCV(_ sender: Any) {
        let vc = (self.contentViewController as! CDMainViewController)
        if vc.right == true {
            vc.RightConstraint.constant = 0.0
            vc.right = false
        } else {
            vc.RightConstraint.constant = 253.0
            vc.right = true
        }
    }
    
    @IBAction func toggleFI(_ sender: Any) {
        let vc = (self.contentViewController as! CDMainViewController)
        if vc.left == true {
            vc.LeftConstraint.constant = 0.0
            vc.left = false
        } else {
            vc.LeftConstraint.constant = 219.0
            vc.left = true
        }
    }
    
}
