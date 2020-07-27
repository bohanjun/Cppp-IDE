//
//  CDUpdateManager.swift
//  C+++
//
//  Created by 23786 on 2020/6/10.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

class CDUpdateManager: NSObject {
    
    private static func getLatestVersionData(completionHandler: @escaping (Data?, Error?) -> Void) {

        let url = URL(string: "https://23786.github.io/cpppideupdate/")!
        
        let downloadTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if data != nil {
                completionHandler(data, nil)
            } else {
                completionHandler(nil, error)
            }
            
        }
        
        downloadTask.resume()
        
    }
    
    static func getVersionAndUpdateInformation(completionHandler: @escaping (String?, String?, String?) -> Void) {
        
        getLatestVersionData { (data, error) in
            
            if let _data = data {
                
                let string = String(data: _data, encoding: .utf8) ?? "Error"
                let start = string.firstIndexOf("LATESTVERSIONBEGIN")
                let end = string.firstIndexOf("LATESTVERSIONEND")
                var strings = string.nsString.substring(with: NSRange(location: start, length: end - start)).components(separatedBy: "<br>")
                strings.removeFirst()
                let latestVersion = strings[0]
                var updateInformation = strings[1].components(separatedBy: "-").joined(separator: "\n- ")
                updateInformation.removeFirst()
                let url = strings[2]
                completionHandler(latestVersion, updateInformation, url)
                
            } else {
                
                completionHandler(nil, nil, nil)
                
            }
            
        }
        
    }
    
    static func getCurrentVersion() -> String? {
        
        let infoDictionary = Bundle.main.infoDictionary
        if let infoDictionary = infoDictionary {
            let appVersion = infoDictionary["CFBundleShortVersionString"] as! String
            return appVersion
        } else {
            return nil
        }
        
    }

}
