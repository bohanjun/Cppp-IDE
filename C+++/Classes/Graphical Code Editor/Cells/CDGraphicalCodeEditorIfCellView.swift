//
//  CDGraphicalCodeEditorIfCellView.swift
//  C+++
//
//  Created by 23786 on 2020/7/21.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

class CDGraphicalCodeEditorIfCellView: CDGraphicalCodeEditorBlockCellView {
    
    @IBOutlet weak var firstItem: NSTextField!
    @IBOutlet weak var secondItem: NSTextField!
    @IBOutlet weak var operatorComboBox: NSComboBox!
    @IBOutlet weak var ifLabel: NSTextField!
    
    override var typeName: String {
        return "If"
    }
    
    override var savedDataKeys: [String] {
        return ["FirstItem", "Operator", "SecondItem"]
    }
    
    override func loadSample() {
        self.dictionary["Operator"] = "=="
        self.dictionary["FirstItem"] = ""
        self.dictionary["SecondItem"] = ""
    }
    
    override var code: String {
        return "if (\(self.firstItem.stringValue) \(self.operatorComboBox.stringValue) \(self.secondItem.stringValue)) " + super.code
    }
    
    override func loadStoredData(string: String) {
        super.loadStoredData(string: string)
        self.firstItem.stringValue = self.dictionary["firstItem"] ?? ""
        self.secondItem.stringValue = self.dictionary["secondItem"] ?? ""
        self.operatorComboBox.stringValue = self.dictionary["Operator"] ?? "=="
    }
    
    override func reloadView() {
        
        for view in subviews {
            if let identifier = view.identifier {
                switch identifier.rawValue {
                    case "If_LineNumber":
                        self.lineNumberButton = view as? NSButton
                    case "If_Background":
                        self.backgroundTextField = view as? NSTextField
                    case "If_EndTextField":
                        self.endTextField = view as? NSTextField
                    case "If_EndTextTextField":
                        self.endTextTextField = view as? NSTextField
                    case "If_Operator":
                        self.operatorComboBox = view as? NSComboBox
                    case "If_FirstTextField":
                        self.firstItem = view as? NSTextField
                    case "If_SecondTextField":
                        self.secondItem = view as? NSTextField
                    case "If_IfLabel":
                        self.ifLabel = view as? NSTextField
                    default:
                        break
                }
            }
        }
        super.reloadView()
        self.firstItem.frame.origin.y = 8.0
        self.secondItem.frame.origin.y = 8.0
        self.ifLabel.frame.origin.y = 8.0
        self.operatorComboBox.frame.origin.y = 5.0
        
    }
    
}
