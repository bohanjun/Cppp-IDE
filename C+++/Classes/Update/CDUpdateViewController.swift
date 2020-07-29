//
//  CDUpdateViewController.swift
//  C+++
//
//  Created by 23786 on 2020/7/29.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

class CDUpdateViewController: NSViewController {
    
    @IBOutlet weak var largeLabel: NSTextField!
    @IBOutlet weak var versionLabel: NSTextField!
    @IBOutlet weak var informationTextView: NSTextView!
    @IBOutlet weak var downloadButton: NSButton!
    var downloadUrl: URL!
    
    @IBAction func viewAllReleases(_ sender: Any?) {
        NSWorkspace.shared.open(URL(string: "https://github.com/23786/Cppp-IDE/releases")!)
    }
    
    @IBAction func downloadThisVersion(_ sender: Any?) {
        NSWorkspace.shared.open(self.downloadUrl!)
    }
    
    @IBAction func close(_ sender: Any?) {
        self.view.window?.close()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public func setup(currentVersion: String, latestVersion: String, information: String, url: URL) {
        
        self.downloadUrl = url
        
        if currentVersion == latestVersion {
            self.largeLabel.stringValue = "You are up to date!"
            self.versionLabel.stringValue = "The latest version is \(latestVersion) and you are using C+++ \(currentVersion)."
            self.informationTextView.string = "You can visit\nhttps://github.com/23786/Cppp-IDE/releases\nto view all releases."
            self.downloadButton.isHidden = true
        } else {
            self.largeLabel.stringValue = "An update is available."
            self.versionLabel.stringValue = "The latest version is \(latestVersion) and you are using C+++ \(currentVersion)."
            self.informationTextView.string = "What's New: \n" + information
        }
        
    }
    
    class var `default`: CDUpdateViewController {
        let storyboard = NSStoryboard(name: "Update", bundle: nil)
        let wc: NSWindowController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("Update Window Controller")) as! NSWindowController
        return wc.contentViewController as! CDUpdateViewController
    }
    
}
