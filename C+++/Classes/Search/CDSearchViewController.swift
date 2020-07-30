//
//  CDSearchViewController.swift
//  C+++
//
//  Created by 23786 on 2020/7/25.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

class CDSearchViewController: NSViewController, NSTableViewDataSource, NSTextFieldDelegate, NSTableViewDelegate, NSWindowDelegate {
    
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var detailView: NSView!
    @IBOutlet weak var textField: NSTextField!
    
    var isDarkMode = false
    var delegate: CDSearchViewControllerDelegate!
    
    var allResults = [CDSearchResult]()
    var filteredResults = [CDSearchResult]()
    
    func controlTextDidChange(_ obj: Notification) {
        
        DispatchQueue.main.async {
            
            self.filteredResults = []
            for i in self.allResults {
                if i.containsKeyword(word: self.textField.stringValue) {
                    self.filteredResults.append(i)
                }
            }
            self.filteredResults.append(CDSearchResult(searchInFileForWord: self.textField.stringValue))
            self.tableView.reloadData()
            self.tableViewSelectionDidChange(Notification(name: NSNotification.Name("")))
            
            
        }
        
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        if tableColumn?.title == "Title" {
            return self.filteredResults[row].title
        } else {
            return self.filteredResults[row].image
        }
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.filteredResults.count
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        for view in self.detailView.subviews {
            view.removeFromSuperview()
        }
        if self.tableView.selectedRowIndexes.count != 0 {
            self.filteredResults[self.tableView.selectedRow].loadResultDetailInView(view: self.detailView, isDarkMode: self.isDarkMode)
        }
    }
    
    
    @IBAction func tableViewClicked(_ sender: Any?) {
        
        let result = self.filteredResults[self.tableView.selectedRow]
        
        switch result.type {
            
            case .fileContent:
                self.delegate?.searchViewController(self, shouldSearchForWordInTextView: self.textField.stringValue)
                self.view.window?.close()
                
            case .recentFiles:
                NSWorkspace.shared.openFile(result.value as! String)
                self.view.window?.close()
                
            case .snippet:
                self.delegate?.searchViewController(self, shouldInsertCodeSnippetWithCode: result.value as! String)
                self.view.window?.close()
                
            default:
                break
            
        }
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textField?.becomeFirstResponder()
        if #available(OSX 10.14, *) {
            switch self.view.effectiveAppearance.name {
                case .aqua, .vibrantLight: self.isDarkMode = false
                case .darkAqua, .vibrantDark: self.isDarkMode = true
                default: self.isDarkMode = false
            }
        } else {
            self.isDarkMode = false
        }
        
        self.allResults[self.tableView.selectedRow].loadResultDetailInView(view: self.detailView, isDarkMode: self.isDarkMode)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        for snippet in CDSnippetTableView.savedSnippets {
            self.allResults.append(CDSearchResult(snippet: snippet))
        }
        for url in NSDocumentController.shared.recentDocumentURLs {
            self.allResults.append(CDSearchResult(recentFileUrl: url))
        }
        self.allResults.append(CDSearchResult(helpWithTitle: "How to use the C+++ Search function?", content: "Just type. Currently, you can search for code snippets, help and recently opened files.\n\nIf you want to search for a code snippet, for example, you can type \"Snippet: DFS\" or \"Code Snippet: DFS\". You can also type \"Recent File: a.cpp\" to search a recently opened file whose name is a.cpp.\n\nYou can double-click the button on the left, to add a snippet to the code, open a recent file, or do other relevant operations.\n"))
        for help in NSApplication.cpppHelp {
            self.allResults.append(CDSearchResult(helpWithTitle: help.key, content: help.value))
        }
        self.filteredResults = self.allResults
        self.filteredResults.append(CDSearchResult(searchInFileForWord: ""))
        self.tableView?.reloadData()
        
    }
    
    func windowDidResignKey(_ notification: Notification) {
        self.view.window?.close()
    }
    
    func windowDidResignMain(_ notification: Notification) {
        self.view.window?.close()
    }
    
}
