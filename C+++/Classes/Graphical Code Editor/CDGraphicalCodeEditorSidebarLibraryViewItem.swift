//
//  CDGraphicalCodeEditorSidebarLibraryViewItem.swift
//  C+++
//
//  Created by 23786 on 2020/7/20.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

class CDGraphicalCodeEditorSidebarLibraryViewItem: NSView, NSDraggingSource, NSPasteboardItemDataProvider {
    
    @IBInspectable var type: String! = ""
    
    func draggingSession(_ session: NSDraggingSession, sourceOperationMaskFor context: NSDraggingContext) -> NSDragOperation {
        return .generic
    }
    
    func pasteboard(_ pasteboard: NSPasteboard?, item: NSPasteboardItem, provideDataForType type: NSPasteboard.PasteboardType) {
        if let pasteboard = pasteboard, type == .string {
            pasteboard.setString(self.type, forType: type)
        }
    }
    
    override func mouseDown(with theEvent: NSEvent) {
        let pasteboardItem = NSPasteboardItem()
        pasteboardItem.setDataProvider(self, forTypes: [.string])
        let draggingItem = NSDraggingItem(pasteboardWriter: pasteboardItem)
        draggingItem.setDraggingFrame(self.bounds, contents: self.type)
        self.beginDraggingSession(with: [draggingItem], event: theEvent, source: self)
    }
    
}
