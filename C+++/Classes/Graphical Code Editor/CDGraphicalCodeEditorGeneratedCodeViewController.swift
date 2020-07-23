//
//  CDGraphicalCodeEditorGeneratedCodeViewController.swift
//  C+++
//
//  Created by 23786 on 2020/7/23.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

class CDGraphicalCodeEditorGeneratedCodeViewController: NSViewController {
    
    @IBOutlet weak var codeEditor: CDCodeEditor!
    
    func setCode(code: String) {
        self.codeEditor?.string = code
    }
    
}
