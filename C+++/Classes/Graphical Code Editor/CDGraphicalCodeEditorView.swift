//
//  CDGraphicalCodeEditorView.swift
//  C+++
//
//  Created by 23786 on 2020/7/20.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

@objc
protocol CDGraphicalCodeEditorViewDelegate {
    
    func codeEditorView(_ view: CDGraphicalCodeEditorView, didDragToPoint point: NSPoint, type: String)
    
}

class CDGraphicalCodeEditorView: CDFlippedView {
    
    var isDragging = false
    @IBOutlet weak var delegate: CDGraphicalCodeEditorViewDelegate!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        isDragging = true
        return .copy
    }
    
    override func draggingExited(_ sender: NSDraggingInfo?) {
        isDragging = false
    }
    
    override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
        return true
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        
        isDragging = false
        let pasteboard = sender.draggingPasteboard
        let point = self.convert(sender.draggingLocation, from: nil)
        let string = pasteboard.string(forType: .string) ?? ""
        self.delegate?.codeEditorView(self, didDragToPoint: point, type: string)
        return true
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.registerForDraggedTypes([.string])
        
    }
    
}
