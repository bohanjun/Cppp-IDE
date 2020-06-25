//
//  NSViewController+NSUserNotificationCenterDelegate.swift
//  C+++
//
//  Created by 23786 on 2020/6/25.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//


import AVFoundation
import NotificationCenter

extension NSViewController : NSUserNotificationCenterDelegate {
    
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
