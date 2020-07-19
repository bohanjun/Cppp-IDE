//
//  CDGraphicalCodeEditorCellView.swift
//  C+++
//
//  Created by 23786 on 2020/7/17.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

protocol CDGraphicalCodeEditorCellViewDelegate {
    
    func codeEditorCellViewDidChangeValue(_ view: CDGraphicalCodeEditorCellView)
    
}

typealias CDGraphicalCodeEditorCellData = Dictionary<String, String>

class CDGraphicalCodeEditorCellView: NSView {
    
    @IBOutlet weak var lineNumberButton: NSButton!
    @IBOutlet weak var backgroundTextField: NSTextField!
    var delegate: CDGraphicalCodeEditorCellViewDelegate!
    
    var code: String {
        return ""
    }
    
    var dictionary: CDGraphicalCodeEditorCellData = [:]
    
    var savedDataKeys: [String] {
        return ["Type"]
    }
    
    func loadStoredData(string: String) {
        for key in savedDataKeys {
            let first = string.firstIndexOf("<KEY=\(key.uppercased())>")
            let last = string.firstIndexOf("</KEY=\(key.uppercased())>")
            let substring = string.nsString.substring(with: NSMakeRange(first + "<KEY=\(key.uppercased())>".count, last - "<KEY=\(key.uppercased())>".count))
            dictionary[key] = substring
        }
    }
    
    var storedData: String {
        var string = ""
        for (key, value) in self.dictionary {
            string.append("<KEY=\(key.uppercased())>\(value)</KEY=\(key.uppercased())> ")
        }
        return string
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

}
