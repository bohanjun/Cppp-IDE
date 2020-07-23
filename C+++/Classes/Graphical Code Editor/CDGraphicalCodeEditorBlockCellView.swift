//
//  CDGraphicalCodeEditorBlockCellView.swift
//  C+++
//
//  Created by 23786 on 2020/7/21.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

class CDGraphicalCodeEditorBlockCellView: CDGraphicalCodeEditorCellView {
    
    var containedCells: [CDGraphicalCodeEditorCellView] = []
    
    @IBOutlet weak var endTextField: NSTextField!
    @IBOutlet weak var endTextTextField: NSTextField!
    
    override var isFlipped: Bool {
        return true
    }
    
    override var storedData: String {
        var string = super.storedData
        for view in self.containedCells {
            string += view.storedData
        }
        string += CDGraphicalCodeDocument.lineSeparator + "\nBlockEnd\n"
        return string
    }
    
    override var code: String {
        var string = "{"
        for cell in self.containedCells {
            for line in cell.code.split(separator: "\n") {
                string += "\t" + line + "\n"
            }
        }
        string += "}"
        return string
    }
    
    func processDragAtPoint(point: NSPoint, view: CDGraphicalCodeEditorCellView) {
        
        if self.containedCells.count == 0 {
            view.loadSample()
            self.containedCells.append(view)
            self.reloadView()
        } else {
            for (index, cell) in self.containedCells.enumerated() {
                let y = self.frame.origin.y + cell.frame.origin.y
                print(self.frame.origin.y + cell.frame.origin.y, point.y, self.frame.origin.y + cell.frame.origin.y + cell.frame.height)
                if cell is CDGraphicalCodeEditorBlockCellView && self.frame.origin.y + cell.frame.origin.y <= point.y &&  point.y <= self.frame.origin.y + cell.frame.origin.y + cell.frame.height {
                    print(true)
                    view.loadSample()
                    cell.reloadView()
                    (cell as! CDGraphicalCodeEditorBlockCellView).addCellView(view: view)
                    self.reloadView()
                }
                if abs(y - point.y) <= 15 {
                    view.loadSample()
                    self.containedCells.insert(view, at: index)
                    self.reloadView()
                }
            }
        }
        
    }
    
    func addCellView(of hierachy: Int = 0, view: CDGraphicalCodeEditorCellView) {
        
        if hierachy == 0 {
            self.containedCells.append(view)
        } else {
            (self.containedCells[self.containedCells.endIndex - 1] as! CDGraphicalCodeEditorBlockCellView).addCellView(of: hierachy - 1, view: view)
            (self.containedCells[self.containedCells.endIndex - 1] as! CDGraphicalCodeEditorBlockCellView).reloadView()
        }
        
    }
    
    override func reloadView() {
        
        super.reloadView()
        var height = 5.0 + backgroundTextField.frame.height + endTextField.frame.height + 10.0
        for view in self.containedCells {
            height += (view.frame.height + 1)
        }
        self.frame.size.height = height
        
        var y: CGFloat = 36.0
        for (i, view) in self.containedCells.enumerated() {
            view.frame.origin = NSMakePoint(35, y)
            view.setLineNumber(self.lineNumberButton.title.nsString.integerValue + i + 1)
            y += view.frame.height + 1
            self.addSubview(view)
        }
        self.backgroundTextField.frame.origin.y = 5.0
        self.lineNumberButton.frame.origin.y = 9.0
        self.endTextField.cornerRadius = 8.0
        self.endTextField.frame.origin.y = y + 2.0
        self.endTextTextField.frame.origin.y = y + 6.0
        
    }
    
}
