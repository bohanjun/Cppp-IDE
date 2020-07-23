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
    func cellViewsInCodeEditorView(_ view: CDGraphicalCodeEditorView) -> [CDGraphicalCodeEditorCellView]
    
}

class CDGraphicalCodeEditorView: CDFlippedView {
    
    var shouldReloadAfterChangingFrame: Bool = true
    
    override var frame: NSRect {
        didSet {
            DispatchQueue.main.async {
                if self.shouldReloadAfterChangingFrame && oldValue != self.frame {
                    self.load(cellViews: self.delegate.cellViewsInCodeEditorView(self))
                }
            }
        }
    }
    
    @IBOutlet weak var delegate: CDGraphicalCodeEditorViewDelegate!
    @IBOutlet weak var viewController: CDGraphicalCodeEditorViewController!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        return .copy
    }
    
    override func draggingExited(_ sender: NSDraggingInfo?) {
        return
    }
    
    override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
        return true
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        
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
