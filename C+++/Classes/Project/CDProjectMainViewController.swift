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
    @IBOutlet weak var fileView: NSView!
    
    weak var document: CDProjectDocument!
    weak var contentVC: CDMainViewController!
    
    // MARK: - Dragging
    var draggedItem: Any? = nil
    
    // MARK: - Document Information
    
    @IBOutlet weak var documentInfoFileNameLabel: NSTextField!
    @IBOutlet weak var documentInfoFileTypeLabel: NSTextField!
    @IBOutlet weak var documentInfoFilePathLabel: NSTextField!
    @IBOutlet weak var documentInfoDescription: NSTextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contentVC = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "Main View Controller") as? CDMainViewController
        contentVC.isOpeningInProjectViewController = true
        self.addChild(contentVC)
        
        self.outlineView?.registerForDraggedTypes([.string])
        
    }
 
    
}
