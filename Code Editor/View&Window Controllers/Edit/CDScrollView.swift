//
//  CDScrollView.swift
//  Code Editor
//
//  Created by apple on 2020/4/21.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

class CDScrollView: NSScrollView {
    
    @IBOutlet var bindedScrollView: NSScrollView!

    
    override func scroll(_ clipView: NSClipView, to point: NSPoint) {
        super.scroll(clipView, to: point)

        bindedScrollView.scroll(bindedScrollView.contentView, to: point)
        
    }
    
}
