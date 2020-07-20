//
//  CDGraphicalCodeEditorUsingNamespaceCellView.swift
//  C+++
//
//  Created by 23786 on 2020/7/20.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

class CDGraphicalCodeEditorUsingNamespaceCellView: CDGraphicalCodeEditorCellView {

    @IBOutlet weak var textField: NSTextField!
    
    override var code: String {
        return "using namespace \(textField.stringValue);"
    }
    
    override var savedDataKeys: [String] {
        return ["NamespaceName"]
    }
    
    override var typeName: String {
        return "UsingNamespace"
    }
    
    override func loadStoredData(string: String) {
        super.loadStoredData(string: string)
        self.textField?.stringValue = self.dictionary["NamespaceName"] ?? ""
    }
    
    func comboBoxSelectionDidChange(_ notification: Notification) {
        self.delegate?.codeEditorCellViewDidChangeValue(self)
    }
    
    override func loadSample() {
        self.dictionary["NamespaceName"] = ""
    }
    
    override func resetIBOutlet() {
        
        for view in subviews {
            if let identifier = view.identifier {
                switch identifier.rawValue {
                    case "UsingNamespace_LineNumber":
                        self.lineNumberButton = view as? NSButton
                    case "UsingNamespace_Background":
                        self.backgroundTextField = view as? NSTextField
                    case "UsingNamespace_TextField":
                        self.textField = view as? NSTextField
                    default:
                        break
                }
            }
        }
        super.resetIBOutlet()
        
    }
    
}

