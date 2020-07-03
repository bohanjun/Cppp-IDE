//
//  CDMainViewController+AddSymbol.swift
//  C+++
//
//  Created by 23786 on 2020/7/3.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

extension CDMainViewController: CDAddSymbolViewControllerDelegate {
    
    func viewController(_ viewController: CDAddSymbolViewController, addText text: String) {
        self.mainTextView.insertText(text, replacementRange: self.mainTextView.selectedRange)
    }
    
    @IBAction func addSymbol(_ sender: NSButton) {
        
        let vc = CDAddSymbolViewController()
        vc.delegate = self
        vc.openInPopover(relativeTo: sender.bounds, of: sender, preferredEdge: .maxY)
        
    }
    
}
