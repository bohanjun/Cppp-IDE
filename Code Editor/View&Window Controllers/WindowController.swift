//
//  WindowController.swift
//  Code Editor
//
//  Created by apple on 2020/3/23.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

var bottom = true, right = true

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
        if bottom == true {
            (self.contentViewController as! ViewController).BottomConstraint.constant = 22.0
            bottom = false
        } else {
            (self.contentViewController as! ViewController).BottomConstraint.constant = 165.0
            bottom = true
        }
    }
    
    @IBAction func toggleCV(_ sender: Any) {
        if right == true {
            (self.contentViewController as! ViewController).RightConstraint.constant = 0.0
            right = false
        } else {
            (self.contentViewController as! ViewController).RightConstraint.constant = 253.0
            right = true
        }
    }
    
}
