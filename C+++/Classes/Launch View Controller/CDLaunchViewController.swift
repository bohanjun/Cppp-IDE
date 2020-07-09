//
//  CDLaunchViewController.swift
//  C+++
//
//  Created by 23786 on 2020/5/24.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

var launchViewController: CDLaunchViewController!

class CDLaunchViewController: NSViewController, CDSettingsViewDelegate, NSTableViewDataSource, NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        switch tableColumn?.title {
            case "":
                return NSWorkspace.shared.icon(forFile: NSDocumentController.shared.recentDocumentURLs[row].path)
                
            case "File":
                return NSDocumentController.shared.recentDocumentURLs[row].lastPathComponent
                
            default: return nil
        }
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        print(NSDocumentController.shared.recentDocumentURLs)
        return NSDocumentController.shared.recentDocumentURLs.count
    }
    
    func didSet() {
        
    }
    
    @IBOutlet weak var welcomeButton: NSButton!
    @IBOutlet weak var aboutButton: NSButton!
    @IBOutlet weak var recentFilesButton: NSButton!
    @IBOutlet weak var titleLabel: NSTextField!
    
    @IBOutlet weak var newFileView: NSView!
    @IBOutlet weak var openFileView: NSView!
    @IBOutlet weak var newProjectView: NSView!
    @IBOutlet weak var recentFilesTableView: NSTableView!
    
    @IBOutlet weak var aboutView: NSView!
    
    @IBAction func welcomeButtonClicked(_ sender: Any?) {
        
        welcomeButton.isBordered = true
        recentFilesTableView.enclosingScrollView?.isHidden = true
        recentFilesButton.isBordered = false
        aboutButton.isBordered = false
        titleLabel.stringValue = "Welcome to C+++"
        newFileView.isHidden = false
        openFileView.isHidden = false
        newProjectView.isHidden = false
        aboutView.isHidden = true
        setButtonWidth()
        
    }
    
    @IBAction func aboutButtonClicked(_ sender: Any?) {
        
        welcomeButton.isBordered = false
        recentFilesTableView.enclosingScrollView?.isHidden = true
        recentFilesButton.isBordered = false
        aboutButton.isBordered = true
        titleLabel.stringValue = "About C+++"
        newFileView.isHidden = true
        openFileView.isHidden = true
        newProjectView.isHidden = true
        aboutView.isHidden = false
        setButtonWidth()
        
    }
    
    @IBAction func recentFilesButtonClicked(_ sender: Any?) {
        
        recentFilesTableView.enclosingScrollView?.isHidden = false
        recentFilesButton.isBordered = true
        welcomeButton.isBordered = false
        aboutButton.isBordered = false
        titleLabel.stringValue = "Recent Files"
        newFileView.isHidden = true
        openFileView.isHidden = true
        newProjectView.isHidden = true
        aboutView.isHidden = true
        setButtonWidth()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        welcomeButtonClicked(nil)
        
        launchViewController = self
        
    }
    
    @IBAction func showSettingsView(_ sender: Any?) {
        
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
            if let ViewController =
                storyboard.instantiateController(
                     withIdentifier: NSStoryboard.SceneIdentifier("CDSettingsViewController")) as? CDSettingsViewController {
                ViewController.delegate = self
                self.presentAsSheet(ViewController)
        }
        
    }
    
    private func setButtonWidth() {
        self.aboutButton.frame = NSMakeRect(8, 150, 140, 40)
        self.welcomeButton.frame = NSMakeRect(8, 226, 140, 40)
        self.recentFilesButton.frame = NSMakeRect(8, 188, 140, 40)
    }
    
}
