//
//  CDUpdateManager(NSViewController Extension).swift
//  C+++
//
//  Created by 23786 on 2020/6/11.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

extension NSViewController {
    
    @IBAction func checkUpdate(_ sender: Any?) {
        
        checkUpdate(alsoShowAlertWhenUpToDate: true)
        
    }
    
    func checkUpdate(alsoShowAlertWhenUpToDate: Bool) {
        
        CDUpdateManager.getVersionAndUpdateInformation { (latestVersion, updateInformation, url) in
            
            DispatchQueue.main.async {
                
                let currentVersion = CDUpdateManager.getCurrentVersion()
                
                if let version = currentVersion, let latest = latestVersion {
                    
                    var title = ""
                    var message = "You can visit \"https://github.com/23786/Cppp-IDE/releases\" to view all releases."
                    if version == latestVersion {
                        title = "You are up to date! The latest version is \(latest) and you are using C+++ \(version)."
                        message = "You can visit \"https://github.com/23786/Cppp-IDE/releases\" to view all releases."
                        if !alsoShowAlertWhenUpToDate {
                            return
                        }
                    } else {
                        title = "An update is available. The latest version is \(latest) and you are using C+++ \(version)."
                        message = "\(updateInformation!)\n\nThe latest version is available at \"\(url!)\". Or you can visit \"https://github.com/23786/Cppp-IDE/releases\" to view all releases."
                    }
                    self.showAlert(title, message)
                    
                } else {
                    
                    if alsoShowAlertWhenUpToDate {
                        self.showAlert("Cannot connnect to the server.", "Please check your internet connection and try again.")
                    }
                    
                }
                
            }
            
        }
        
    }
    
}
