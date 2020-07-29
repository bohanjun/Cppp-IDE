//
//  NSViewController Extension.swift
//  C+++
//
//  Created by 23786 on 2020/6/25.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import NotificationCenter

extension NSViewController {
    
    func showAlert(_ title: String, _ message: String) {
        
        guard self.view.window != nil else {
            return
        }
        
        let alert = NSAlert()
        alert.messageText = title
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK")
        alert.informativeText = message
        alert.beginSheetModal(for: self.view.window!, completionHandler: { returnCode in })
        
    }
    
}


extension NSObject: NSUserNotificationCenterDelegate {
    
    func sendUserNotification(title: String, subtitle: String) {
        let userNotification = NSUserNotification()
        userNotification.title = title
        userNotification.subtitle = subtitle
        userNotification.informativeText = ""
        let userNotificationCenter = NSUserNotificationCenter.default
        userNotificationCenter.delegate = self
        userNotificationCenter.scheduleNotification(userNotification)
    }
    
    public func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool{
        return true
    }
    
}
