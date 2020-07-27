//
//  CDSearchResult.swift
//  C+++
//
//  Created by 23786 on 2020/7/27.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

class CDSearchResult: NSObject {
    
    public init(snippet: CDSnippetTableViewCell) {
        super.init()
        
        self.actualTitle = "Snippet: " + snippet.title
        self.displayTitle = snippet.title
        self.type = .snippet
        self.value = snippet.code
        self.image = snippet.image
        
    }
    
    public init(recentFileUrl url: URL) {
        super.init()
        
        self.actualTitle = "Recent File: " + url.lastPathComponent
        self.displayTitle = url.lastPathComponent
        self.type = .recentFiles
        self.value = url.path
        self.image = NSWorkspace.shared.icon(forFile: self.value as! String)
        
    }
    
    public init(helpWithTitle title: String, content: String) {
        super.init()
        
        self.actualTitle = "Help: " + title
        self.displayTitle = title
        self.value = content
        self.image = NSImage(named: "Help")!
        self.type = .help
        
    }
    
    
    enum `Type`: Int {
        case none = 0x00
        case snippet = 0x01
        case recentFiles = 0x02
        case fileContent = 0x03
        case help = 0x04
    }
    
    var type: Type = .none
    var actualTitle: String = ""
    var displayTitle: String = ""
    var value: Any!
    var image: NSImage!
    
    func loadResultDetailInView(view: NSView, isDarkMode: Bool = false) {
        
        switch self.type {
            case .snippet:
                
                let codeEditor = CDCodeEditor(frame: view.bounds)
                codeEditor.string = self.value as! String
                codeEditor.drawsBackground = false
                if isDarkMode {
                    codeEditor.highlightr?.setTheme(to: CDSettings.shared.darkThemeName)
                } else {
                    codeEditor.highlightr?.setTheme(to: CDSettings.shared.lightThemeName)
                }
                codeEditor.didChangeText()
                codeEditor.isEditable = false
                
                let scrollView = NSScrollView(frame: view.bounds)
                scrollView.hasVerticalScroller = true
                scrollView.hasHorizontalScroller = true
                scrollView.drawsBackground = false
                scrollView.documentView = codeEditor
                
                
                view.addSubview(scrollView)
            
            case .recentFiles:
                let imageView = NSImageView(frame: view.bounds)
                imageView.image = NSWorkspace.shared.icon(forFile: self.value as! String)
                imageView.alignment = .center
                imageView.imageScaling = .scaleProportionallyDown
                view.addSubview(imageView)
                
            default: break
        }
        
    }
    
}
