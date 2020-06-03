//
//  CDTestViewController.swift
//  C+++
//
//  Created by 23786 on 2020/6/3.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

class CDTestViewController: NSViewController {
    
    var fileURL: String = ""
    
    @IBOutlet weak var first: CDTestPointView!
    @IBOutlet weak var second: CDTestPointView!
    @IBOutlet weak var third: CDTestPointView!
    @IBOutlet weak var fourth: CDTestPointView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        self.first?.isEnabled = true
        self.second?.isEnabled = true
        self.third?.isEnabled = true
        self.fourth?.isEnabled = true
        
    }
    
}
