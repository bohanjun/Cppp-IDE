//
//  CDCodeCompletionViewController.swift
//  C+++
//
//  Created by 23786 on 2020/6/28.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

class CDCodeCompletionViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    
    var results: [CDCompletionResult]!
    var popover: NSPopover!
    @IBOutlet weak var tableView: NSTableView!
    var delegate: CDCodeCompletionViewControllerDelegate!
    var range: NSRange!
    
    
    // MARK: NSTableViewDataSource
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: NSTableView, didClick tableColumn: NSTableColumn) {
        
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        if results.count >= row {
            let result = self.results[row]
            if tableColumn?.title == "Text" {
                let string = NSMutableAttributedString(string: result.textForDisplay, attributes: [.font: NSFont(name: CDSettings.shared.fontName ?? "Menlo", size: 14.0)!])
                if result.hasReturnType {
                    string.addAttribute(.font, value: NSFont.systemFont(ofSize: 14.0, weight: .bold), range: NSMakeRange(0, "\(result.returnType!)  ".count))
                    for i in result.matchedRanges {
                        string.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange("\(result.returnType!)  ".count + i.location, i.length))
                    }
                } else {
                    for i in result.matchedRanges {
                        string.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: i)
                    }
                }
                return string
            } else {
                switch result.type {
                    case .class: return NSImage(named: "Class")
                    case .enum: return NSImage(named: "Enum")
                    case .function: return NSImage(named: "Function")
                    case .namespace: return NSImage(named: "Namespace")
                    case .preprocessing: return NSImage(named: "Preprocessing")
                    case .typealias: return NSImage(named: "Typealias")
                    case .struct: return NSImage(named: "Struct")
                    case .variable: return NSImage(named: "Variable")
                    default: return nil
                }
            }
        } else {
            return nil
        }
        
    }
    
    deinit {
        
        tableView.delegate = nil
        tableView.dataSource = nil
        if self.popover.isShown == true {
            popover.close()
        }
        
    }
    
    override func awakeFromNib() {
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.cell?.font = CDSettings.shared.font
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.tableView?.selectRowIndexes(IndexSet(integer: 0), byExtendingSelection: false)
        self.tableView?.cell?.font = CDSettings.shared.font
        
    }
    
    func closePopover() {
        popover?.close()
    }
    
    func openInPopover(relativeTo rect: NSRect, of view: NSView, preferredEdge edge: NSRectEdge) {
        
        if popover == nil {
            
            popover = NSPopover()
            popover.animates = false
            popover.behavior = .transient
            popover.contentViewController = self
            popover.show(relativeTo: rect, of: view, preferredEdge: edge)
            
        }
        
    }
    
    override func keyDown(with event: NSEvent) {
        
        if event.specialKey == NSEvent.SpecialKey(rawValue: 13) && self.tableView.selectedRow != -1 {
            
            self.delegate?.codeCompletionViewController(self, didSelectItemWithTitle: self.results[self.tableView.selectedRow].completionString, range: self.range)
            self.closePopover()
            return
            
        }
        
        self.closePopover()
        NSApplication.shared.sendEvent(event)
        
    }
    
}
