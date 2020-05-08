//
//  CDTableViewCellInfoViewController.swift
//  C+++
//
//  Created by 23786 on 2020/5/7.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa


@objc
protocol CDTableViewCellInfoViewControllerDelegate {
    
    @objc optional func didAddToCode(code: String)
    @objc optional func didRemoveItem(senderTitle: String)
    @objc optional func willClose()
    @objc optional func didSetColor(image: NSImage)
    @objc optional func didAddItem(title: String, image: NSImage, code: String)
    
}


class CDTableViewCellInfoViewController: NSViewController {
        
    let imageNames = ["Code", "YellowCode", "GreenCode", "PurpleCode", "BlueCode"]
    
    @IBOutlet weak var titleLabel: NSTextField!
    @IBOutlet weak var textView: CDTextView!
    @IBOutlet weak var imageView: NSButton!
    @IBOutlet weak var addToCodeButton: NSButton!
    @IBOutlet weak var removeButton: NSButton!
    
    public var imageNameIndex: Int = 0
    
    /// The CDTableView.
    var delegate: CDTableViewCellInfoViewControllerDelegate!
    /// The CDTableViewCell.
    var closeDelegate: CDTableViewCellInfoViewControllerDelegate!
    /// The CDTextView.
    var addToCodeDelegate: CDTableViewCellInfoViewControllerDelegate!
    
    @IBAction func addToCode(_ sender: Any) {
        
        self.addToCodeDelegate.didAddToCode!(code: self.textView.string)
        self.closeDelegate.willClose?()
        
    }
    
    @objc func removeItem() {
        
        self.delegate.didRemoveItem!(senderTitle: self.titleLabel.stringValue)
        self.closeDelegate.willClose?()
        
    }
    
    @objc func addItem() {
        
        self.delegate.didAddItem!(title: self.titleLabel.stringValue, image: self.imageView.image!, code: self.textView.string)
        self.closeDelegate.willClose?()
        
    }
    
    @IBAction func ChangeImage(_ sender: NSButton) {
        
        imageNameIndex += 1
        imageNameIndex %= 5
        self.imageView.image = NSImage(named: imageNames[imageNameIndex])!
        self.closeDelegate.didSetColor?(image: self.imageView.image!)
        
    }
    
    /** Setup the view controller.
    - parameter title: The title.
    - parameter image: The image.
    - parameter code: The code.
    - parameter mode: True when Add Mode and False when Normal Mode.
    - returns: none
    */
    func setup(title: String, image: NSImage, code: String, mode: Bool) {
        
        self.loadView()
        self.titleLabel.stringValue = title
        self.textView.string = code
        self.imageView.image = image
        
        if #available(OSX 10.14, *) {
            self.view.appearance = darkAqua
            self.view.window?.appearance = darkAqua
            self.view.wantsLayer = true
            self.view.layer?.backgroundColor = NSColor.darkGray.cgColor
            self.textView.highlightr?.setTheme(to: "Agate")
        } else {
            self.view.appearance = aqua
            self.textView.highlightr?.setTheme(to: "Xcode")
        }
        
        self.textView.didChangeText()
        self.removeButton.target = self
        self.removeButton.action = #selector(removeItem)
        
        if mode == true {
            
            self.titleLabel.isEditable = true
            self.addToCodeButton.isHidden = true
            self.removeButton.action = #selector(addItem)
            self.removeButton.title = "Add"
            
        }
        
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do view setup here.
        
    }
    
}
