//
//  CDProjectSidebarViewController.swift
//  C+++
//
//  Created by 23786 on 2020/8/10.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

class CDProjectMainViewController: NSViewController {
    
    @IBOutlet weak var outlineView: NSOutlineView!
    
    weak var document: CDProjectDocument!
    
    // MARK: - Document Information
    
    @IBOutlet weak var documentInfoFileNameLabel: NSTextField!
    @IBOutlet weak var documentInfoFileTypeLabel: NSTextField!
    @IBOutlet weak var documentInfoFilePathLabel: NSTextField!
    @IBOutlet weak var documentInfoDescription: NSTextView!
    
 
    
}
