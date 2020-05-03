//
//  Settings.swift
//  Code Editor
//
//  Created by apple on 2020/4/16.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

class Settings: NSObject, NSCoding {
    
    // MARK: - Properties
    
    var FontName: String!
    var FontSize: Int!
    var LightThemeName: String!
    var DarkThemeName: String!
    var AutoComplete: Bool!
    
    // MARK: - Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .libraryDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("C+++").appendingPathComponent("Settings")
    
    // MARK: - Types
    
    struct PropertyKey {
        static let FontName = "FontName"
        static let FontSize = "FontSize"
        static let LightThemeName = "LightThemeName"
        static let DarkThemeName = "DarkThemeName"
        static let AutoComplete = "AutoComplete"
    }
    
    
    // MARK: - Initialization
    
    init?(_ FontName: String?, _ FontSize: Int?, _ LightThemeName: String?, _ DarkThemeName: String?, _ AutoComplete: Bool?) {
        
        // Initialize stored properties.
        self.FontName = FontName
        self.FontSize = FontSize
        self.LightThemeName = LightThemeName
        self.DarkThemeName = DarkThemeName
        self.AutoComplete = AutoComplete
        
    }
    
    
    // MARK: - NSCoding
    
    func encode(with coder: NSCoder) {
        coder.encode(FontName, forKey: PropertyKey.FontName)
        coder.encode(FontSize, forKey: PropertyKey.FontSize)
        coder.encode(LightThemeName, forKey: PropertyKey.LightThemeName)
        coder.encode(DarkThemeName, forKey: PropertyKey.DarkThemeName)
        coder.encode(AutoComplete, forKey: PropertyKey.AutoComplete)
    }
    
    required convenience init?(coder: NSCoder) {
        
        let name = coder.decodeObject(forKey: PropertyKey.FontName) as? String
        let size = coder.decodeObject(forKey: PropertyKey.FontSize) as? Int
        let light = coder.decodeObject(forKey: PropertyKey.LightThemeName) as? String
        let dark = coder.decodeObject(forKey: PropertyKey.DarkThemeName) as? String
        let bool = coder.decodeObject(forKey: PropertyKey.AutoComplete) as? Bool
        
        self.init(name, size, light, dark, bool)
        
    }
    
    
}
