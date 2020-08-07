//
//  CDCodeEditorScrollView.swift
//  C+++
//
//  Created by apple on 2020/4/21.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

class CDCodeEditorScrollView: NSScrollView {
    
    @IBOutlet weak var bindedScrollView: CDCodeEditorScrollView!
    @IBOutlet weak var bindedMinimapView: CDMinimapView?
    
    override func scroll(_ clipView: NSClipView, to point: NSPoint) {
        super.scroll(clipView, to: point)
        
        bindedScrollView?.superScroll(bindedScrollView.contentView, to: point)
        bindedScrollView?.reflectScrolledClipView(bindedScrollView.contentView)
        bindedMinimapView?.codeEditorScrollViewDidScrollToPoint(point: point)
        
    }
    
    func superScroll(_ clipView: NSClipView, to point: NSPoint) {
        
        super.scroll(clipView, to: point)
        
    }
    
}
