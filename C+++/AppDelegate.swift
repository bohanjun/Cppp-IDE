//
//  AppDelegate.swift
//  C+++
//
//  Created by apple on 2020/3/23.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa 

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let documentController = CDDocumentController()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        if CDSettings.shared == nil || CDCompileSettings.shared == nil {
            initDefaultData()
        }
        if CDSettings.shared.checkUpdateAfterLaunching {
            NSApplication.shared.checkUpdate(alsoShowAlertWhenUpToDate: false)
        }
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        return .terminateNow
    }
    
}
