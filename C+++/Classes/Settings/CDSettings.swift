//
//  Settings.swift
//  C+++
//
//  Created by apple on 2020/4/16.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

class CDSettings: NSObject, NSCoding {
    
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
        
        static let fontName = "FontName"
        static let fontSize = "FontSize"
        static let lightThemeName = "LightThemeName"
        static let darkThemeName = "DarkThemeName"
        static let autoComplete = "AutoComplete"
        
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
        
        coder.encode(fontName, forKey: PropertyKey.fontName)
        coder.encode(fontSize, forKey: PropertyKey.fontSize)
        coder.encode(lightThemeName, forKey: PropertyKey.lightThemeName)
        coder.encode(darkThemeName, forKey: PropertyKey.darkThemeName)
        coder.encode(autoComplete, forKey: PropertyKey.autoComplete)
        
    }
    
    required convenience init?(coder: NSCoder) {
        
        let name = coder.decodeObject(forKey: PropertyKey.fontName) as? String
        let size = coder.decodeObject(forKey: PropertyKey.fontSize) as? Int
        let light = coder.decodeObject(forKey: PropertyKey.lightThemeName) as? String
        let dark = coder.decodeObject(forKey: PropertyKey.darkThemeName) as? String
        let bool = coder.decodeObject(forKey: PropertyKey.autoComplete) as? Bool
        
        self.init(name, size, light, dark, bool)
        
    }
    
    var font: NSFont {
        
        return NSFont(name: self.fontName, size: CGFloat(self.fontSize))!
        
    }
    
    class var shared: CDSettings! {
        get {
            return NSKeyedUnarchiver.unarchiveObject(withFile: CDSettings.archiveURL.path) as? CDSettings
        }
        set {
            NSKeyedArchiver.archiveRootObject(newValue!, toFile: CDSettings.archiveURL.path)
        }
    }
    
    
}
