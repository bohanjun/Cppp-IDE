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
    
    override var frame: NSRect {
        didSet {
            if oldValue != frame {
                self.imageView.frame.origin = NSMakePoint(0, 0)
            }
        }
    }
    
}
