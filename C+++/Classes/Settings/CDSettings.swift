//
//  Settings.swift
//  C+++
//
//  Created by apple on 2020/4/16.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa
import NotificationCenter

class CDSettings: NSObject, NSCoding {
    
    // MARK: - Properties
    
    // Introduced in v1.0.1
    var fontName: String!
    var fontSize: Int!
    var lightThemeName: String!
    var darkThemeName: String!
    var autoComplete: Bool!
    
    // Introduced in v2.1.1
    var codeCompletion: Bool!
    var checkUpdateAfterLaunching: Bool!
    var showLiveIssues: Bool!
    
    static let settingsDidChangeNotification: NSNotification.Name = NSNotification.Name(rawValue: "CDSettingsDidChange")
    
    
    
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
        static let codeCompletion = "CodeCompletion"
        static let checkUpdateAfterLaunching = "CheckUpdateAfterLaunching"
        static let showLiveIssues = "ShowLiveIssues"
        
    }
    
    
    // MARK: - Initialization
    
    init?(_ fontName: String? = "Courier", _ fontSize: Int? = 15, _ lightThemeName: String? = "Xcode", _ darkThemeName: String? = "Agate", _ autoComplete: Bool? = true, _ codeCompletion: Bool? = true, _ checkUpdateAfterLaunching: Bool? = true, _ showsLiveIssue: Bool? = true) {
        
        // Initialize stored properties.
        self.fontName = fontName
        self.fontSize = fontSize
        self.lightThemeName = lightThemeName
        self.darkThemeName = darkThemeName
        self.autoComplete = autoComplete
        self.codeCompletion = codeCompletion
        self.checkUpdateAfterLaunching = checkUpdateAfterLaunching
        self.showLiveIssues = showsLiveIssue
        
    }
    
    
    // MARK: - NSCoding
    
    func encode(with coder: NSCoder) {
        
        coder.encode(fontName, forKey: PropertyKey.fontName)
        coder.encode(fontSize, forKey: PropertyKey.fontSize)
        coder.encode(lightThemeName, forKey: PropertyKey.lightThemeName)
        coder.encode(darkThemeName, forKey: PropertyKey.darkThemeName)
        coder.encode(autoComplete, forKey: PropertyKey.autoComplete)
        coder.encode(codeCompletion, forKey: PropertyKey.codeCompletion)
        coder.encode(checkUpdateAfterLaunching, forKey: PropertyKey.checkUpdateAfterLaunching)
        coder.encode(showLiveIssues, forKey: PropertyKey.showLiveIssues)
        
    }
    
    required convenience init?(coder: NSCoder) {
        
        let name = coder.decodeObject(forKey: PropertyKey.fontName) as? String
        let size = coder.decodeObject(forKey: PropertyKey.fontSize) as? Int
        let light = coder.decodeObject(forKey: PropertyKey.lightThemeName) as? String
        let dark = coder.decodeObject(forKey: PropertyKey.darkThemeName) as? String
        let bool = coder.decodeObject(forKey: PropertyKey.autoComplete) as? Bool
        let codeCompletion = coder.decodeObject(forKey: PropertyKey.codeCompletion) as? Bool
        let checksUpdate = coder.decodeObject(forKey: PropertyKey.checkUpdateAfterLaunching) as? Bool
        let liveIssues = coder.decodeObject(forKey: PropertyKey.showLiveIssues) as? Bool
        
        self.init(name, size, light, dark, bool, codeCompletion, checksUpdate, liveIssues)
        
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
            NotificationCenter.default.post(name: CDSettings.settingsDidChangeNotification, object: nil)
        }
    }
    
    
}
