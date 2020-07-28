//
//  CDMainViewController+Search.swift
//  C+++
//
//  Created by 23786 on 2020/7/28.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

extension CDMainViewController: CDSearchViewControllerDelegate {
    
    @IBAction func showSearchView(_ sender: NSButton) {
        
        let vc = CDSearchViewController()
        vc.delegate = self
        vc.openInPopover(relativeTo: sender.bounds, of: sender, preferredEdge: .minX)
        
    }
    
    func searchViewController(_ vc: CDSearchViewController, shouldSearchForWordInTextView word: String) {
        let control = NSControl()
        control.tag = 1
        self.mainTextView?.performFindPanelAction(control)
    }
    
    func searchViewController(_ vc: CDSearchViewController, shouldInsertCodeSnippetWithCode code: String) {
        self.mainTextView?.insertText(code, replacementRange: self.mainTextView.selectedRange)
    }
    
}
