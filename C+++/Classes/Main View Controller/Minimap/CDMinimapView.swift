//
//  CDMinimapView.swift
//  C+++
//
//  Created by 23786 on 2020/8/6.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

class CDMinimapView: CDFlippedView {
    
    @IBOutlet weak var imageView: NSImageView!
    @IBOutlet weak var scrollerView: CDMinimapScrollerView!
    @IBOutlet weak var codeEditorScrollView: CDCodeEditorScrollView!
    
    func didDragScroller() {
        let a = self.codeEditorScrollView.frame.height
        let b = self.codeEditorScrollView.documentView!.frame.height
        let c = self.imageView.frame.height
        self.scrollerView.frame.size.height = (a / b) * c
        let d = self.scrollerView.frame.origin.y
        self.codeEditorScrollView.scroll(codeEditorScrollView.contentView, to: NSMakePoint(0, d / c * b))
        self.codeEditorScrollView.reflectScrolledClipView(self.codeEditorScrollView.contentView)
    }
    
    func codeEditorScrollViewDidScrollToPoint(point: NSPoint) {
        let a = self.codeEditorScrollView.frame.height
        let b = self.codeEditorScrollView.documentView!.frame.height
        let c = self.imageView.frame.height
        let d = point.y
        self.scrollerView.frame.size.height = (a / b) * c
        // print(d / b * c)
        self.scrollerView.frame.origin.y = (d / b) * c
    }
    
}
