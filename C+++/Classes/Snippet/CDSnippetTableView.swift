//
//  CDSnippetTableView.swift
//  C+++
//
//  Created by 23786 on 2020/5/7.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa
import os.log

class CDSnippetTableView: CDFlippedView, CDSnippetPopoverViewControllerDelegate {
    
    var explicitCellHeight: CGFloat {
        get {
            if self.cells.count == 0 {
                return 45.0
            } else {
                return self.cells[0].explicitHeight
            }
        }
        set {
            for cell in self.cells {
                cell.explicitHeight = newValue
            }
            self.setup(cells: self.cells)
        }
    }
    
    var cellDisplaysImage: Bool {
        get {
            if self.cells.count == 0 {
                return true
            } else {
                return self.cells[0].displaysImage
            }
        }
        set {
            for cell in self.cells {
                cell.displaysImage = newValue
            }
            self.setup(cells: self.cells)
        }
    }
    
    static let archievePath = FileManager().urls(for: .libraryDirectory, in: .userDomainMask).first!.appendingPathComponent("C+++").appendingPathComponent("Snippets")
    
    func save() {
        
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(cells, toFile:
                                                                    CDSnippetTableView.archievePath.path)
        
        if !isSuccessfulSave {
            os_log("Failed to save...", type: .error)
        }
        
    }
    
    
    /// Load sample snippets.
    private func loadSample() {
        
        for (name, code) in sampleSnippets {

            self.append(cell: CDSnippetTableViewCell(title: name, image: NSImage(named: "Code")!, code: code, width: 210.0))
            
        }
        
    }
    
    /// Load the snippets.
    /// - returns: [CDTableViewCell]
    func load() -> [CDSnippetTableViewCell]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: CDSnippetTableView.archievePath.path) as? [CDSnippetTableViewCell]
    }
    
    
    /// Default code snippets.
    private let sampleSnippets: KeyValuePairs = [
        "For Statement": "\nfor (int i = , i <= , i ++ ) {\n\t\n}",
        "If Statement": "\nif () {\n\t\n}",
        "While Statement": "\nwhile () {\n\t\n}",
        "If-else Statement": "\nif () {\n\t\n} else {\n\t\n}",
        "Struct Declaration": "\nstruct TNode {\n\tint a, b;\n\tTNode(int x, int y) { a = x; b = y; }\n};",
        "Switch Statement" : "\nswitch () {\n\tcase : break;\n\tcase : break;\n}",
        "Function Declaration": "\nvoid func(int a, ...) {\n\t\n}",
        "DFS": "\nvoid dfs(int t) {\n\tif (/*Reaches the End*/) {\n\t\t/*Output;*/\n\t\treturn;\n\t}\n\tfor (int i = ; /*Every Possible Answers*/; i ++) {\n\t\tif (!gVis[i]) {\n\t\t\tgVis[i] = 1; // Change\n\t\t\t// Do Something;\n\t\t\tdfs(t + 1);\n\t\t\tgVis[i] = 0; // Recover\n\t\t}\n\t}\n}",
        "Bubble Sort": "\nfor (int i = 1; i <= n - 1; i ++) {\n\tfor (int j = 1; j <= n - i; j ++) {\n\t\tif(a[j] < a[j + 1]) swap(a[j], a[j + 1]);\n\t}\n}",
        "Bucket Sort": "\nint a;\nfor (int i = 0; i < arr.count; i ++) {\n\tscanf(\"%d\", &a);\n\tn[a] += 1;\n}\n// output\nfor (int i = 0; i < arr.count; i ++) {\n\tfor(int j = 1; j <= n[i]; j ++)\n\t\tprintf(\"%d \", i);\n}",
        "Binary Search": "\nvoid binarySearch(int x) {\n\tint L = 1, R = MAXN, mid;\n\twhile (L < R) {\n\t\tmid = (L + R) / 2;\n\t\tif (x >= n[mid]) {\n\t\t\tL = mid;\n\t\t} else {\n\t\t\tR = mid - 1;\n\t\t}\n\t}\n\tprintf(\"%d\", n[L]);\n}",
        "More...": "Press the \"+\" button below\nand add your own code snippets.\nAfter you add a snippet, it\nwill not be editable.\n\nCode Snippet is a small portion\nof re-usable source code. They\nallow a programmer to avoid\ntyping repetitive code during\nprogramming."
    ]
    
    @objc func didAddItem(title: String, image: NSImage, code: String) {
        
        let cell = CDSnippetTableViewCell(title: title, image: image, code: code, width: 210.0)
        self.append(cell: cell)
        
    }
    
    func search(for title: String, in cells: [CDSnippetTableViewCell]) {
        
        var filteredItems = [CDSnippetTableViewCell]()
        for item in cells {
            if item.title.lowercased().contains(title.lowercased()) {
                filteredItems.append(item)
            }
        }
        self.setup(cells: filteredItems)
        
    }
    
    @objc func didRemoveItem(senderTitle: String) {
        
        for (index, cell) in self.cells.enumerated() {
            
            if cell.title == senderTitle {
                self.remove(at: index)
                break
            }
            
        }
        
    }
    
    var cells : [CDSnippetTableViewCell] = []

    override var autoresizesSubviews: Bool {
        get {
            return false
        }
        set {}
    }
    
    
    // MARK: - init
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        if let savedSnippets = load() {
            
            cells += savedSnippets
            setup(cells: self.cells)
            
        } else {
            
            loadSample()
            
        }
        
        
    }
    
    
    // MARK: - Append and remove
    func append(cell: CDSnippetTableViewCell) {
        
        self.cells.append(cell)
        setup(cells: self.cells)
        save()
        
    }
    
    func remove(at index: Int) {
        
        self.cells.remove(at: index)
        setup(cells: self.cells)
        save()
        
    }
    
    
    
    // MARK: - Setup
    func setup(cells: [CDSnippetTableViewCell]) {
        
        var y: CGFloat = 0
        
        for view in self.subviews {
            view.removeFromSuperview()
        }
        
        for cell in cells {
            
            cell.frame.origin = NSPoint(x: 0, y: y)
            cell.bounds.origin = NSPoint(x: 0, y: y)
            cell.titleLabel.frame.origin = NSPoint(x: 0, y: y)
            cell.titleLabel.bounds.origin = NSPoint(x: 0, y: y)
            self.addSubview(cell)
            y += cell.bounds.height - 3
            
        }
        
        if !(self is CDProjectTableView) {
            y += 33
        }
        
        self.frame.size.height = y + 20
        self.bounds.size.height = y + 20
        self.superview?.frame.size.height = y + 20
        self.superview?.bounds.size.height = y + 20
        
    }
    
    func allItemTitles() -> [String] {
        
        var res = [String]()
        for i in self.cells {
            res.append(i.title!)
        }
        return res
        
    }
    
    static func snippetCompletionResults() -> [CDCompletionResult] {
        
        var results = [CDCompletionResult]()
        var result: CDCompletionResult
        for cell in (NSKeyedUnarchiver.unarchiveObject(withFile: archievePath.path) as! [CDSnippetTableViewCell]) {
            result = CDCompletionResult(returnType: cell.title, typedText: cell.code, otherTexts: [String]())
            results.append(result)
        }
        return results
        
    }
    
}
