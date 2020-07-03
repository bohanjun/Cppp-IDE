//
//  CDMainViewController+SegmentedControl.swift
//  C+++
//
//  Created by 23786 on 2020/7/3.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

extension CDMainViewController {
    
    @IBAction func didClickSegmentedControl(_ sender: NSSegmentedControl) {
        
        switch sender.selectedSegment {
            
            case 0:
                scrollViewOfTableView.isHidden = true
                addSnippetButton.isHidden = true
                fileView.isHidden = false
            
            case 1:
                fileView.isHidden = true
                scrollViewOfTableView.isHidden = false
                addSnippetButton.isHidden = false
                snippetAndDiagnositcsTableView.explicitCellHeight = 45.0
                snippetAndDiagnositcsTableView.cellDisplaysImage = true
                self.snippetAndDiagnositcsTableView.setup(cells: snippetAndDiagnositcsTableView.cells)
                
            case 2:
                fileView.isHidden = true
                scrollViewOfTableView.isHidden = false
                addSnippetButton.isHidden = true
                snippetAndDiagnositcsTableView.explicitCellHeight = 32.0
                snippetAndDiagnositcsTableView.cellDisplaysImage = false
                self.updateDiagnostics()
                snippetAndDiagnositcsTableView.setup(cells: diagnosticsCells)
                
            default: break
            
        }
        
    }
    
}
