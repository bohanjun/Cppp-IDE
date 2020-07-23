//
//  CDGraphicalCodeEditorView+UI.swift
//  C+++
//
//  Created by 23786 on 2020/7/21.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

extension CDGraphicalCodeEditorView {
    
    @discardableResult
    func load(cellViews: [CDGraphicalCodeEditorCellView]) -> String {
        
        for view in self.subviews {
            view.removeFromSuperview()
        }
        
        var y: CGFloat = 10.0
        var lineNumber: Int = 1
        var string = ""
        
        for view in cellViews {
            
            view.frame.origin.y = y
            view.setLineNumber(lineNumber)
            self.addSubview(view)
            string += view.storedData
            
            y += (view.frame.height + 1)
            lineNumber += 1
            
        }
        
        self.shouldReloadAfterChangingFrame = false
        self.frame.size.height = y + 20
        self.superview?.frame.size.height = y + 20
        self.shouldReloadAfterChangingFrame = true
        
        return string
        
    }
    
}
