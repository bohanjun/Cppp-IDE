//
//  CDProject.swift
//  C+++
//
//  Created by 23786 on 2020/8/10.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

enum CDProjectItem: Codable {
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.singleValueContainer()
        do {
            let project = try container.decode(CDProject.self)
            self = .project(project)
        } catch {
            do {
                let document = try container.decode(CDProject.Document.self)
                self = .document(document)
            } catch {
                let folder = try! container.decode(CDProject.Folder.self)
                self = .folder(folder)
            }
        }
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
            case .document(let document): try container.encode(document)
            case .folder(let folder): try container.encode(folder)
            case .project(let project): try container.encode(project)
        }
    }
    
    
    case project(CDProject)
    case folder(CDProject.Folder)
    case document(CDProject.Document)
    
}

class CDProject: NSObject, Codable {
    
    var hasChildren: Bool
    var typeName: String
    var children: [CDProjectItem]
    
    
    
    class Document: NSObject, Codable {
        
        var hasChildren: Bool
        var typeName: String
        var children: [CDProjectItem]
        var fileDescription: String?
        
        var title: String {
            return self.path.nsString.lastPathComponent
        }
        
        
        var path: String = ""
        
        init(path: String = "Document") {
            self.path = path
            self.hasChildren = false
            self.fileDescription = ""
            self.typeName = "File"
            self.children = []
        }
        
        /*func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(self.hasChildren, forKey: CodingKeys.hasChildren)
            try container.encode(self.typeName, forKey: CodingKeys.typeName)
            try container.encode(self.children, forKey: CodingKeys.children)
            try container.encode(self.path, forKey: CodingKeys.path)
        }
        
        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let typeName = try container.decode(String.self, forKey: CodingKeys.typeName)
            let hasChildren = try container.decode(Bool.self, forKey: CodingKeys.hasChildren)
            let children = try container.decode(Array<CDProjectItem>.self, forKey: CodingKeys.children)
            let path = try container.decode(String.self, forKey: CodingKeys.path)
            let path = try container.decode(String.self, forKey: CodingKeys.path)
            self.typeName = typeName
            self.hasChildren = hasChildren
            self.children = children
            self.path = path
        }*/
        
        enum CodingKeys: String, CodingKey {
            case typeName = "ITEM_TYPE"
            case hasChildren = "HAS_CHILDREN"
            case children = "CHILDREN_ARRAY"
            case path = "FILE_PATH"
            case fileDescription = "FILE_DESCRIPTION"
        }
        
        
    }
    
    
    
    
    class Folder: NSObject, Codable {
        
        var hasChildren: Bool
        var typeName: String
        var children: [CDProjectItem]
        var fileDescription: String?
        var name: String = ""
        
        var title: String {
            return self.name
        }
        
        init(name: String = "Folder") {
            self.name = name
            self.hasChildren = true
            self.typeName = "Folder"
            self.fileDescription = ""
            self.children = []
        }
        
        enum CodingKeys: String, CodingKey {
            
            case hasChildren = "HAS_CHILDREN"
            case typeName = "ITEM_TYPE"
            case children = "CHILDREN_ARRAY"
            case name = "FOLDER_NAME"
            case fileDescription = "FILE_DESCRIPTION"
            
        }
        
        /*
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(self.hasChildren, forKey: CodingKeys.hasChildren)
            try container.encode(self.typeName, forKey: CodingKeys.typeName)
            try container.encode(self.children, forKey: CodingKeys.children)
            try container.encode(self.name, forKey: CodingKeys.name)
        }
        
        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let typeName = try container.decode(String.self, forKey: CodingKeys.typeName)
            let hasChildren = try container.decode(Bool.self, forKey: CodingKeys.hasChildren)
            let children = try container.decode(Array<CDProjectItem>.self, forKey: CodingKeys.children)
            let name = try container.decode(String.self, forKey: CodingKeys.name)
            self.typeName = typeName
            self.hasChildren = hasChildren
            self.children = children
            self.name = name
        }
        */
        
    }
    
    
    
    var compileCommand = ""
    var version = "1.0"
    var fileDescription: String?
    var title: String {
        return "Project"
    }
    
    init(compileCommand: String? = "", version: String? = "1.0") {
        self.typeName = "Project"
        self.hasChildren = true
        self.fileDescription = ""
        self.children = []
        self.compileCommand = compileCommand ?? ""
        self.version = version ?? "1.0"
    }
    
    /*required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let typeName = try container.decode(String.self, forKey: CodingKeys.typeName)
        let hasChildren = try container.decode(Bool.self, forKey: CodingKeys.hasChildren)
        let children = try container.decode(Array<CDProjectItem>.self, forKey: CodingKeys.children)
        let compileCommand = try container.decode(String.self, forKey: CodingKeys.compileCommand)
        let version = try container.decode(String.self, forKey: CodingKeys.version)
        self.typeName = typeName
        self.hasChildren = hasChildren
        self.children = children
        self.compileCommand = compileCommand
        self.version = version
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.hasChildren, forKey: CodingKeys.hasChildren)
        try container.encode(self.typeName, forKey: CodingKeys.typeName)
        try container.encode(self.children, forKey: CodingKeys.children)
        try container.encode(self.compileCommand, forKey: CodingKeys.compileCommand)
        try container.encode(self.version, forKey: CodingKeys.version)
    }*/
    
    enum CodingKeys: String, CodingKey {
        
        case typeName = "ITEM_TYPE"
        case hasChildren = "HAS_CHILDREN"
        case children = "CHILDREN_ARRAY"
        case compileCommand = "COMPILE_COMMAND"
        case version = "VERSION"
        case fileDescription = "FILE_DESCRIPTION"
        
    }
    
    
}
