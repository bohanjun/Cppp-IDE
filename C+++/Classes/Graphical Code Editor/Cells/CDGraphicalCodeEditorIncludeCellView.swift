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
        return ["IncludeOrImport", "FileName"]
    }
    
    override var typeName: String {
        return "Include"
    }
    
    override func loadStoredData(string: String) {
        super.loadStoredData(string: string)
        self.comboBox?.stringValue = self.dictionary["IncludeOrImport"] ?? "#include"
        self.fileNameTextField?.stringValue = self.dictionary["FileName"] ?? ""
    }
    
    func comboBoxSelectionDidChange(_ notification: Notification) {
        self.delegate?.codeEditorCellViewDidChangeValue(self)
    }
    
    override func loadSample() {
        self.dictionary["IncludeOrImport"] = "#include"
        self.dictionary["FileName"] = ""
    }
    
    override func resetIBOutlet() {
        
        for view in subviews {
            if let identifier = view.identifier {
                switch identifier.rawValue {
                    case "Include_LineNumber":
                        self.lineNumberButton = view as? NSButton
                    case "Include_Background":
                        self.backgroundTextField = view as? NSTextField
                    case "Include_TextField":
                        self.fileNameTextField = view as? NSTextField
                    case "Include_ComboBox":
                        self.comboBox = view as? NSComboBox
                    default:
                        break
                }
            }
        }
        super.resetIBOutlet()
        
    }
    
}
