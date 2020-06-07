//
//  NSApplication Extensions.swift
//  C+++
//
//  Created by 23786 on 2020/5/27.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

extension NSApplication {
    
    @IBAction func showWebsite(_ sender: Any) {
        NSWorkspace.shared.open(URL(string: "https://ericnth.cn/cppp-ide-macos/")!)
    }
    
    @IBAction func showGithub(_ sender: Any) {
        NSWorkspace.shared.open(URL(string: "https://github.com/23786/cppp-ide")!)
    }
    
    @IBAction func _showHelp(_ sender: Any) {
        
        if let window = self.keyWindow {
            window.contentViewController?.showAlert("Help", """
            1. Why does the app always crash?
            If the application always crashes, please delete all files at path \"~/Library/C+++\" and restart the app. If the crash still happens, please create an issue at GitHub repo: \"https://github.com/23786/cppp-ide\".
            
            2. How to install C++ Compiler?
            C++ Compiler is not included in the C+++ app. You need to install it.
            Open \"Terminal\" and type g++, press enter. A dialog will appear. Follow the instructions and install the commane line tools. Or you can directly compile a file in C+++ and that dialog will appear too.
            If you have already installed it or installed Xcode, you needn't install g++ again.
            
            3. Why I can't use \"bits/stdc++.h\"?
            That's because you are using macOS, and that header file is not available in macOS.
            
            4. Why I can't use \"windows.h\"?
            You are using macOS. Don't dream of using windows.h in Mac!
            
            5. The app displays a lot of error codes when openning a document.
            Maybe you are openning a file which was previously edited in Windows or other operating systems which do not follow the UTF-8 encoding. The default encoding of the document is UTF-8 in C+++ (which is also the default one in macOS). If the document openning operation fails, the app will try WindowsCP1252 encoding. Otherwise Unicode.
            """)
        }
        
    }
    
    @IBAction func about(_ sender: Any) {
        
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        if let windowController =
            storyboard.instantiateController(
                withIdentifier: NSStoryboard.SceneIdentifier("Launch View Controller")) as? NSWindowController {
            (windowController.contentViewController as! CDLaunchViewController).aboutButtonClicked(self)
            windowController.showWindow(self)
        }
        
    }
    
}
