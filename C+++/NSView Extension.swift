//
//  NSView Extension.swift
//  C+++
//
//  Created by 23786 on 2020/7/20.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

extension NSView {
    
    var cornerRadius: CGFloat {
        get {
            return self.layer?.cornerRadius ?? 0.0
        }
        set {
            self.wantsLayer = true
            self.layer?.masksToBounds = true
            self.layer?.cornerRadius = newValue
        }
    }
    
}
