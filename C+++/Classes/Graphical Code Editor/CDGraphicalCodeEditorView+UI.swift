//
//  CDGraphicalCodeEditorView+UI.swift
//  C+++
//
//  Created by 23786 on 2020/7/21.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

extension CDGraphicalCodeEditorView {
    
    func load(cellViews: [CDGraphicalCodeEditorCellView]) {
        
        var y: CGFloat = 10.0
        var lineNumber: Int = 1
        
        for view in cellViews {
            
            view.frame.origin.y = y
            view.setLineNumber(lineNumber)
            self.addSubview(view)
            
            y += (view.frame.height + 1)
            lineNumber += 1
            
        }
        
        self.shouldreloadAfterChangingFrame = false
        self.frame.size.height = y
        self.superview?.frame.size.height = y
        self.shouldreloadAfterChangingFrame = true
        
    }
    
}
