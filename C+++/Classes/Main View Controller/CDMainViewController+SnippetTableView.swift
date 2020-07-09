//
//  CDMainViewController+SnippetTableView.swift
//  C+++
//
//  Created by 23786 on 2020/7/3.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

extension CDMainViewController : CDSnippetPopoverViewControllerDelegate {
    
    @IBAction func addItem(_ sender: NSButton) {
        
        let vc = CDSnippetPopoperViewController()
        vc.setup(title: "Edit your title", image: NSImage(named: "Code")!, code: "Edit your code here.\nYou can also click the image to\n change the color of it.", isEditable: true)
        vc.delegate_tableView = self.snippetAndDiagnositcsTableView
        vc.openInPopover(relativeTo: sender.bounds, of: sender, preferredEdge: .maxY)
        
    }
    
    
    // CDSnippetPopoverViewControllerDelegate
    func popoverViewController(_ viewController: CDSnippetPopoperViewController, shouldAddToCode code: String) {
        self.mainTextView.insertText(code, replacementRange: self.mainTextView.selectedRange)
    }
    
    
    @IBAction func search(_ sender: NSButton) {
        
        switch sender.title {
            
            case "Search":
                sender.title = "Back"
                
                var cells: [CDSnippetTableViewCell]
                if self.segmentedControl.selectedSegment == 2 {
                    cells = self.diagnosticsCells
                } else {
                    cells = self.snippetAndDiagnositcsTableView.cells
                }
                self.snippetAndDiagnositcsTableView.search(for: self.snippetSearchField.stringValue, in: cells)
                self.snippetSearchField.isEnabled = false
                self.addSnippetButton.isEnabled = false
                
            case "Back":
                sender.title = "Search"
                
                var cells: [CDSnippetTableViewCell]
                if self.segmentedControl.selectedSegment == 2 {
                    cells = self.diagnosticsCells
                } else {
                    cells = self.snippetAndDiagnositcsTableView.cells
                }
                self.snippetAndDiagnositcsTableView.setup(cells: cells)
                self.snippetSearchField.isEnabled = true
                self.snippetSearchField.stringValue = ""
                self.addSnippetButton.isEnabled = false
                
            default:
                break
            
        }
        
    }
    
}
