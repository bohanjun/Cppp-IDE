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
    
    var fontName: String!
    var fontSize: Int!
    var lightThemeName: String!
    var darkThemeName: String!
    var autoComplete: Bool!
    
    // MARK: - Archiving Paths
    
    static let documentsDirectory = FileManager().urls(for: .libraryDirectory, in: .userDomainMask).first!
    static let archiveURL = documentsDirectory.appendingPathComponent("C+++").appendingPathComponent("Settings")
    
    // MARK: - Types
    
    struct PropertyKey {
        
        static let FontName = "FontName"
        static let FontSize = "FontSize"
        static let LightThemeName = "LightThemeName"
        static let DarkThemeName = "DarkThemeName"
        static let AutoComplete = "AutoComplete"
        
    }
    
    
    // MARK: - Initialization
    
    init?(_ fontName: String?, _ fontSize: Int?, _ lightThemeName: String?, _ darkThemeName: String?, _ autoComplete: Bool?) {
        
        // Initialize stored properties.
        self.fontName = fontName
        self.fontSize = fontSize
        self.lightThemeName = lightThemeName
        self.darkThemeName = darkThemeName
        self.autoComplete = autoComplete
        
    }
    
    
    // MARK: - NSCoding
    
    func encode(with coder: NSCoder) {
        
        coder.encode(fontName, forKey: PropertyKey.FontName)
        coder.encode(fontSize, forKey: PropertyKey.FontSize)
        coder.encode(lightThemeName, forKey: PropertyKey.LightThemeName)
        coder.encode(darkThemeName, forKey: PropertyKey.DarkThemeName)
        coder.encode(autoComplete, forKey: PropertyKey.AutoComplete)
        
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
