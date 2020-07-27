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
        
        self.title = "Snippet: " + snippet.title
        self.type = .snippet
        self.value = snippet.code
        self.image = snippet.image
        
    }
    
    public init(recentFileUrl url: URL) {
        super.init()
        
        self.title = "Recent File: " + url.lastPathComponent
        self.type = .recentFiles
        self.value = url.path
        self.image = NSWorkspace.shared.icon(forFile: self.value as! String)
        
    }
    
    
    enum `Type`: Int {
        case none = 0x00
        case snippet = 0x01
        case recentFiles = 0x02
        case fileContent = 0x03
    }
    
    var type: Type = .none
    var title: String = ""
    var value: Any!
    var image: NSImage!
    
    func loadResultDetailInView(view: NSView) {
        
        switch self.type {
            case .snippet:
                let codeEditor = CDCodeEditor(frame: view.bounds)
                codeEditor.string = self.value as! String
                codeEditor.didChangeText()
                codeEditor.drawsBackground = false
                view.addSubview(codeEditor)
            
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
