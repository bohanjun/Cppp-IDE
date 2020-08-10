//
//  CDProject.swift
//  C+++
//
//  Created by 23786 on 2020/8/10.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

class CDProjectItem: NSObject, Codable {
    
    var title: String {
        return "Title"
    }
    var hasChildren: Bool {
        return true
    }
    var children = [CDProjectItem]()
    
}

class CDProject: CDProjectItem {
    
    
    
    
    class Document: CDProjectItem {
        
        override var title: String {
            return "\(path.nsString.lastPathComponent)"
        }
        
        override var hasChildren: Bool {
            return false
        }
        
        var path: String = ""
        
        override init() {
            super.init()
            self.path = "Document"
        }
        
        
        required init(from decoder: Decoder) throws {
            try super.init(from: decoder)
        }
        
    }
    
    
    
    
    class Folder: CDProjectItem {
        
        override var hasChildren: Bool {
            return true
        }
        
        
        var name: String = ""
        
        override var title: String {
            return self.name
        }
        
        override init() {
            super.init()
            self.name = "Folder"
        }
        
        required init(from decoder: Decoder) throws {
            try super.init(from: decoder)
        }
        
    }
    
    
    
    var compileCommand = ""
    var version = "1.0"
    override var title: String {
        return "Project"
    }
    override var hasChildren: Bool {
        return true
    }
    
    init(compileCommand: String? = "", version: String? = "1.0", documents: [Document]? = [Document]()) {
        super.init()
        self.compileCommand = compileCommand ?? ""
        self.version = version ?? "1.0"
        self.children = documents ?? [Document]()
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
    
}
