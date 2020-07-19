//
//  CDGraphicalCodeEditorIncludeCellView.swift
//  C+++
//
//  Created by 23786 on 2020/7/19.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

class CDGraphicalCodeEditorIncludeCellView: CDGraphicalCodeEditorCellView, NSComboBoxDelegate {

    @IBOutlet weak var comboBox: NSComboBox!
    @IBOutlet weak var fileNameTextField: NSTextField!
    
    override var code: String {
        return "\(comboBox.stringValue) \(fileNameTextField.stringValue)"
    }
    
    override var savedDataKeys: [String] {
        return ["Type", "IncludeOrImport", "FileName"]
    }
    
    override func loadStoredData(string: String) {
        super.loadStoredData(string: string)
        self.comboBox.stringValue = self.dictionary["IncludeOrImport"] ?? "#include"
        self.fileNameTextField.stringValue = self.dictionary["FileName"] ?? ""
    }
    
    func comboBoxSelectionDidChange(_ notification: Notification) {
        self.delegate.codeEditorCellViewDidChangeValue(self)
    }
    
}
