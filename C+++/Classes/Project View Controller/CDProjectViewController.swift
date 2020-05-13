//
//  CDProjectViewController.swift
//  C+++
//
//  Created by 23786 on 2020/5/12.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

class CDProjectViewController: NSViewController {
    
    var filePaths = [String]()
    @IBOutlet var tableView: CDProjectTableView!
    @IBOutlet weak var textField: NSTextField!
    
    @IBAction func save(_ sender: Any?) {
        
        (self.representedObject as! CpppProject).compileCommand = textField.stringValue
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override var representedObject: Any? {
        didSet {
            for i in children {
                i.representedObject = self.representedObject
            }
        }
    }
    
}
