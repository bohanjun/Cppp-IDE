//
//  CDUpdateManager.swift
//  C+++
//
//  Created by 23786 on 2020/6/10.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

class CDUpdateManager: NSObject {
    
    static func getLatestVersionData(completionHandler: @escaping (Data?, Error?) -> Void) {

        let textFileURL = URL(string: "https://github.com/23786/Cppp-IDE/blob/master/LatestVersion.txt")!
        
        let downloadTask = URLSession.shared.dataTask(with: textFileURL) { (data, response, error) in
            
            if data != nil {
                print("true")
                completionHandler(data, nil)
            } else {
                print("true")
                completionHandler(nil, error)
            }
            
        }
        
        downloadTask.resume()
        
    }

}
