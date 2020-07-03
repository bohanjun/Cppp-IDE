//
//  CDMainViewController+Diagnostics.swift
//  C+++
//
//  Created by 23786 on 2020/7/3.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

extension CDMainViewController {
    
    func updateDiagnostics() {
        
        self.getDiagnostics()
        diagnosticsCells = [CDSnippetTableViewCell]()
        for diagnostic in self.diagnostics {
            let cell = CDSnippetTableViewCell(title: diagnostic.description, image: nil, code: "Line:\(diagnostic.line)\nColumn:\(diagnostic.column)\n\(diagnostic.spelling!)", width: 210.0)
            cell.explicitHeight = 32.0
            cell.titleLabel?.font? = NSFont.systemFont(ofSize: 12.0)
            diagnosticsCells.append(cell)
            
            switch diagnostic.severity {
                
                case CKDiagnosticSeverityWarning:
                    self.lineNumberTextView.markLineNumber(line: Int(diagnostic.line), color: .yellow)
                case CKDiagnosticSeverityError, CKDiagnosticSeverityFatal:
                    self.lineNumberTextView.markLineNumber(line: Int(diagnostic.line), color: .orange)
                default:
                    break
            }
            
        }
        
        if self.segmentedControl.selectedSegment == 2 {
            snippetAndDiagnositcsTableView.setup(cells: diagnosticsCells)
        }
        
    }
    
    private func getDiagnostics() {
        
        self.diagnostics = [CKDiagnostic]()
        for item in CKTranslationUnit(text: self.mainTextView.string, language: CKLanguageCPP).diagnostics! {
            
            if let diagnostic = item as? CKDiagnostic {
                
                if diagnostic.range.contains(self.mainTextView.selectedRange.location) {
                    continue
                }
                
                self.diagnostics.append(diagnostic)
                
            }
            
        }
        
    }
    
}
