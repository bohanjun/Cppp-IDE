//
//  Content.swift
//  C+++
//
//  Created by apple on 2020/3/23.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

class CDDocumentContent: NSObject {
    
    @objc dynamic var contentString = ""
    
    public init(contentString: String) {
        self.contentString = contentString
    }
    
}

extension CDDocumentContent {
    
    func read(from data: Data) {
        
        if let string = String(bytes: data, encoding: .utf8) {
            print("utf8")
            contentString = string
        } else if let string = String(bytes: data, encoding: .windowsCP1252) {
            print("windowsCP1252")
            contentString = string
        } else if let string = String(bytes: data, encoding: .unicode) {
            print("unicode")
            contentString = string
        }
        
    }
    
    func data() -> Data? {
        
        return contentString.data(using: .utf8)
        
    }
    
}
