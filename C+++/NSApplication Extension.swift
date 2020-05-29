//
//  NSApplication Extensions.swift
//  C+++
//
//  Created by 23786 on 2020/5/27.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

extension NSApplication {
    
    
    @IBAction func showTutorial(_ sender: Any) {
        NSWorkspace.shared.open(URL(string: "https://www.runoob.com/cplusplus/cpp-tutorial.html")!)
    }
    
    @IBAction func showWebsite(_ sender: Any) {
        NSWorkspace.shared.open(URL(string: "https://ericnth.cn/cppp-ide-macos/")!)
    }
    
    @IBAction func showGithub(_ sender: Any) {
        NSWorkspace.shared.open(URL(string: "https://github.com/23786/cppp-ide")!)
    }
    
    
}
