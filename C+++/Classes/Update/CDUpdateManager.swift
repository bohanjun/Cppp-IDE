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

        let textFileURL = URL(string: "https://23786.github.io/")!
        
        let downloadTask = URLSession.shared.dataTask(with: textFileURL) { (data, response, error) in
            
            if data != nil {
                completionHandler(data, nil)
            } else {
                completionHandler(nil, error)
            }
            
        }
        
        downloadTask.resume()
        
    }
    
    static func getVersionAndUpdateInformation(completionHandler: @escaping (String?, String?, String?) -> Void) {
        
        CDUpdateManager.getLatestVersionData { (data, error) in
            
            if let _data = data {
                
                let string = String(data: _data, encoding: .utf8) ?? "Error"
                let start = string.firstIndexOf("LATESTVERSIONBEGIN")
                let end = string.firstIndexOf("LATESTVERSIONEND")
                var strings = (string as NSString).substring(with: NSRange(location: start, length: end - start)).components(separatedBy: "<br>")
                strings.removeFirst()
                let latestVersion = strings[0]
                var updateInformation = strings[1].components(separatedBy: "-").joined(separator: "\n")
                updateInformation.removeFirst()
                let url = strings[2]
                print(latestVersion, updateInformation, url, separator: "\n")
                completionHandler(latestVersion, updateInformation, url)
                
            } else {
                
                completionHandler(nil, nil, nil)
                
            }
            
        }
        
    }

}
