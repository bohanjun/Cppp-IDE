//
//  CDLaunchViewController.swift
//  C+++
//
//  Created by 23786 on 2020/5/24.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

class CDLaunchViewController: NSViewController, CDSettingsViewDelegate {
    
    func didSet() {
        
    }
    
    @IBOutlet weak var welcomeButton: NSButton!
    @IBOutlet weak var aboutButton: NSButton!
    @IBOutlet weak var titleLabel: NSTextField!
    
    @IBOutlet weak var newFileView: NSView!
    @IBOutlet weak var openFileView: NSView!
    @IBOutlet weak var newProjectView: NSView!
    
    @IBOutlet weak var aboutView: NSView!
    
    @IBAction func welcomeButtonClicked(_ sender: Any?) {
        
        welcomeButton.state = .on
        aboutButton.state = .off
        titleLabel.stringValue = "Welcome to C+++"
        newFileView.isHidden = false
        openFileView.isHidden = false
        newProjectView.isHidden = false
        aboutView.isHidden = true
        
    }
    
    @IBAction func aboutButtonClicked(_ sender: Any?) {
        
        welcomeButton.state = .off
        aboutButton.state = .on
        titleLabel.stringValue = "About C+++"
        newFileView.isHidden = true
        openFileView.isHidden = true
        newProjectView.isHidden = true
        aboutView.isHidden = false
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        welcomeButtonClicked(nil)
        
        welcomeButton.bezelStyle = .smallSquare
        aboutButton.bezelStyle = .smallSquare
        
    }
    
    @IBAction func showSettingsView(_ sender: Any?) {
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
            if let ViewController =
                storyboard.instantiateController(
                     withIdentifier: NSStoryboard.SceneIdentifier("SettingsViewController")) as? CDSettingsViewController {
                ViewController.delegate = self
                self.presentAsSheet(ViewController)
        }
    }
    
}
