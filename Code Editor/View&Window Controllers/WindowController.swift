//
//  WindowController.swift
//  Code Editor
//
//  Created by apple on 2020/3/23.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa



class WindowController: NSWindowController, NSWindowDelegate {
    
    
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
        let vc = (self.contentViewController as! ViewController)
        if vc.bottom == true {
            vc.BottomConstraint.constant = 22.0
            vc.bottom = false
        } else {
            vc.BottomConstraint.constant = 165.0
            vc.bottom = true
        }
    }
    
    @IBAction func toggleCV(_ sender: Any) {
        let vc = (self.contentViewController as! ViewController)
        if vc.right == true {
            vc.RightConstraint.constant = 0.0
            vc.right = false
        } else {
            vc.RightConstraint.constant = 253.0
            vc.right = true
        }
    }
    
}
