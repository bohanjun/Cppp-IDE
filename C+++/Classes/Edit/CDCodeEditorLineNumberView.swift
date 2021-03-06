//
//  CDCodeEditorLineNumberView.swift
//  C+++
//
//  Created by 23786 on 2020/7/30.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

class CDCodeEditorLineNumberView: CDFlippedView {
    
    @IBOutlet weak var codeEditor: CDCodeEditor!
    var buttonsArray = [CDCodeEditorLineNumberViewButton]()
    var debugLines = [Int]()
    var shouldReloadAfterChangingFrame: Bool = true
    
    override var frame: NSRect {
        didSet {
            DispatchQueue.main.async {
                if self.shouldReloadAfterChangingFrame && oldValue != self.frame {
                    self.draw(self.codeEditor.lineRects)
                }
            }
        }
    }
    
    func draw(_ array: [NSRect]) {
        
        var lineNumber = 0
        for view in self.subviews {
            view.removeFromSuperview()
        }
        
        self.buttonsArray = [CDCodeEditorLineNumberViewButton]()
        
        for item in array {
            let button = CDCodeEditorLineNumberViewButton(frame: NSMakeRect(2.0, item.origin.y, 34.0, item.height))
            button.isBordered = false
            button.font = NSFont(name: CDSettings.shared.fontName, size: CGFloat(CDSettings.shared.fontSize) * 0.92)
            button.target = self
            button.action = #selector(buttonClicked(_:))
            lineNumber += 1
            button.title = "\(lineNumber)"
            button.sizeToFit()
            button.frame.origin.x = self.bounds.width - button.frame.size.width - 2.0
            self.addSubview(button)
            if self.debugLines.contains(lineNumber) {
                button.markAsBreakpointLine()
                self.debugLines.remove(at: self.debugLines.firstIndex(of: lineNumber)!)
            }
            self.buttonsArray.append(button)
        }
        
        self.shouldReloadAfterChangingFrame = false
        self.frame.size.height = (array.last?.origin.y ?? 0) + (array.last?.height ?? 0)
        self.superview?.frame.size.height = (array.last?.origin.y ?? 0) + (array.last?.height ?? 0)
        self.shouldReloadAfterChangingFrame = true
        
    }
    
    @objc func buttonClicked(_ sender: CDCodeEditorLineNumberViewButton) {
        sender.markAsBreakpointLine()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
