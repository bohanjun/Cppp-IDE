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
        
        CDUpdateManager.getVersionAndUpdateInformation { (latestVersion, updateInformation, url) in
            
            DispatchQueue.main.async {
                let currentVersion = CDUpdateManager.getCurrentVersion()
                if let version = currentVersion, let latest = latestVersion {
                    var title = ""
                    var message = "You can visit https://github.com/23786/cppp-ide/releases to view all releases."
                    if version == latestVersion {
                        title = "You are up to date! The latest version is \(latest) and you are using C+++ \(version)."
                        message = ""
                    } else {
                        title = "An update is available. The latest version is \(latest) and you are using C+++ \(version)."
                        message = "Update Information: \n\(updateInformation!)\n\nThe latest version is available at \(url!). Or you can visit https://github.com/23786/cppp-ide/releases to view all releases."
                    }
                    self.showAlert(title, message)
                }
            }
        }
        
    }
    
}
