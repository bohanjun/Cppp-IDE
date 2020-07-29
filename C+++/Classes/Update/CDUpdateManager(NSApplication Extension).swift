//
//  CDUpdateManager(NSViewController Extension).swift
//  C+++
//
//  Created by 23786 on 2020/6/11.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

extension NSApplication {
    
    @IBAction func checkUpdate(_ sender: Any?) {
        
        checkUpdate(alsoShowAlertWhenUpToDate: true)
        
    }
    
    func checkUpdate(alsoShowAlertWhenUpToDate: Bool) {
        
        if alsoShowAlertWhenUpToDate {
            self.sendUserNotification(title: "Checking For Updates...", subtitle: "This may take a few seconds.")
        }
        
        CDUpdateManager.getVersionAndUpdateInformation { (latestVersion, updateInformation, url) in
            
            DispatchQueue.main.async {
                
                if latestVersion != nil && updateInformation != nil && url != nil {
                    
                    if latestVersion! == updateInformation! && !alsoShowAlertWhenUpToDate {
                        return
                    }
                    let vc = CDUpdateViewController.default
                    vc.setup(currentVersion: CDUpdateManager.getCurrentVersion()!, latestVersion: latestVersion!, information: updateInformation!, url: URL(string: url!)!)
                    vc.view.window?.windowController?.showWindow(self)
                    
                } else {
                    
                    
                    if alsoShowAlertWhenUpToDate {
                        self.sendUserNotification(title: "Check Updates Failed", subtitle: "Please check your network connection.")
                    }
                    
                }
                
            }
            
        }
        
    }
    
}
