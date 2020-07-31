//
//  CDCodeEditorLineNumberView.swift
//  C+++
//
//  Created by 23786 on 2020/7/30.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

class CDCodeEditorLineNumberView: CDFlippedView {
    
    var buttonArrays = [CDCodeEditorLineNumbetViewButton]()
    
    func draw(_ array: [NSRect]) {
        
        var lineNumber = 0
        for view in self.subviews {
            view.removeFromSuperview()
        }
        
        for item in array {
            let button = CDCodeEditorLineNumbetViewButton(frame: NSMakeRect(2.0, item.origin.y, 34.0, item.height))
            button.isBordered = false
            button.font = .systemFont(ofSize: CGFloat(CDSettings.shared.fontSize) * 0.9, weight: .light)
            button.alignment = .right
            button.target = self
            button.action = #selector(buttonClicked(_:))
            lineNumber += 1
            button.title = "\(lineNumber)"
            self.addSubview(button)
            self.buttonArrays.append(button)
        }
        
        self.frame.size.height = (array.last?.origin.y ?? 0) + (array.last?.height ?? 0)
        self.superview?.frame.size.height = (array.last?.origin.y ?? 0) + (array.last?.height ?? 0)
        
    }
    
    @objc func buttonClicked(_ sender: CDCodeEditorLineNumbetViewButton) {
        sender.markAsDebugLine()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
