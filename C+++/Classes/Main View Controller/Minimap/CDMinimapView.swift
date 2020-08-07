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
    @IBOutlet weak var codeEditorScrollView: CDLineNumberScrollView!
    
    func didDragScroller() {
        let a = self.codeEditorScrollView.frame.height
        let b = self.codeEditorScrollView.documentView!.frame.height
        let c = self.imageView.frame.height
        print("height: \(a / b * c)")
        self.scrollerView.frame.size.height = (a / b) * c
        let d = self.scrollerView.frame.origin.y
        print("scrollTo: \(d / c * b)")
        self.codeEditorScrollView.scroll(codeEditorScrollView.contentView, to: NSMakePoint(0, d / c * b))
    }
    
}
