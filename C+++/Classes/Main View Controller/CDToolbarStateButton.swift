//
//  CDToolbarStateButton.swift
//  C+++
//
//  Created by 23786 on 2020/6/26.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

class CDToolbarStateButton: NSButton {

    override func performClick(_ sender: Any?) {
        // Do nothing
    }
    
    override func mouseDown(with event: NSEvent) {
        // Do nothing
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        self.state = .on
        
    }
    
}
