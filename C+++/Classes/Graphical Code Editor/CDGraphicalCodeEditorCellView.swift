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
    func deleteCodeEditorCellView(_ view: CDGraphicalCodeEditorCellView)
    
}

typealias CDGraphicalCodeEditorCellData = Dictionary<String, String>

class CDGraphicalCodeEditorCellView: NSView {
    
    @IBOutlet var lineNumberButton: NSButton!
    @IBOutlet var backgroundTextField: NSTextField!
    var delegate: CDGraphicalCodeEditorCellViewDelegate!
    
    var code: String {
        return ""
    }
    
    var typeName: String {
        return "Universal"
    }
    
    var dictionary: CDGraphicalCodeEditorCellData = [:]
    
    var savedDataKeys: [String] {
        return [String]()
    }
    
    func loadStoredData(string: String) {
        for key in savedDataKeys {
            let first = string.firstIndexOf("<KEY=\(key.uppercased())>")
            let last = string.firstIndexOf("</KEY=\(key.uppercased())>")
            let range = NSMakeRange(first + "<KEY=\(key.uppercased())>".count, last - first - "</KEY=\(key.uppercased())>".count + 1)
            let substring = string.nsString.substring(with: range)
            dictionary[key] = substring
        }
    }
    
    func setLineNumber(_ number: Int) {
        self.lineNumberButton?.title = "\(number)"
    }
    
    func loadSample() {
        return
    }
    
    var storedData: String {
        var string = CDGraphicalCodeDocument.lineSeparator + "\n" + self.typeName + "\n"
        for (key, value) in self.dictionary {
            string.append("<KEY=\(key.uppercased())>\(value)</KEY=\(key.uppercased())>\n")
        }
        return string
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
    
    func reloadView() {
        self.backgroundTextField.cornerRadius = 8.0
        let menu = NSMenu(title: "Menu")
        menu.addItem(NSMenuItem(title: "Remove", action: #selector(deleteSelf), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Move Up", action: #selector(moveSelfUp), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Move Down", action: #selector(moveSelfDown), keyEquivalent: ""))
        self.menu = menu
    }
    
    @objc func deleteSelf() {
        self.delegate?.deleteCodeEditorCellView(self)
    }
    
    @objc func moveSelfUp() {
        
    }
    
    @objc func moveSelfDown() {
        
    }
    
}
