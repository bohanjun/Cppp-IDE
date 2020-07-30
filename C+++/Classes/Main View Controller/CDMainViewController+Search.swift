//
//  CDMainViewController+Search.swift
//  C+++
//
//  Created by 23786 on 2020/7/28.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

extension CDMainViewController: CDSearchViewControllerDelegate {
    
    @IBAction func showSearchView(_ sender: Any?) {
        
        let vc = CDSearchViewController()
        vc.delegate = self
        let wc = NSWindowController()
        let window = NSWindow()
        window.contentViewController = vc
        window.styleMask = .init(arrayLiteral: .titled, .fullSizeContentView)
        window.titlebarAppearsTransparent = true
        window.contentView = vc.view
        window.isMovableByWindowBackground = true
        window.delegate = vc
        window.center()
        wc.contentViewController = vc
        wc.window = window
        wc.showWindow(self)
        
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
