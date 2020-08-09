//
//  CDCodeEditor Extension.swift
//  C+++
//
//  Created by 23786 on 2020/8/9.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

extension CDCodeEditor {
    
    @IBAction func biggerFont(_ sender: Any?) {
        
        let settings = CDSettings.shared
        settings?.fontSize += 1
        CDSettings.shared = settings
        self.font = CDSettings.shared.font
        
    }
    
    @IBAction func smallerFont(_ sender: Any?) {
        
        let settings = CDSettings.shared
        settings?.fontSize -= 1
        CDSettings.shared = settings
        self.font = CDSettings.shared.font
        
    }
    
}
