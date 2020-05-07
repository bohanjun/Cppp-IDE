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
    
}

class CDTableViewCellInfoViewController: NSViewController {
    
    @IBOutlet weak var titleLabel: NSTextField!
    @IBOutlet weak var textView: CDTextView!
    @IBOutlet weak var imageView: NSImageView!
    
    var delegate: CDTableViewCellInfoViewControllerDelegate!
    var closeDelegate: CDTableViewCellInfoViewControllerDelegate!
    var addToCodeDelegate: CDTableViewCellInfoViewControllerDelegate!
    
    @IBAction func addToCode(_ sender: Any) {
        
        self.addToCodeDelegate.didAddToCode!(code: self.textView.string)
        self.closeDelegate.willClose?()
        
    }
    
    @IBAction func removeItem(_ sender: Any) {
        
        self.delegate.didRemoveItem!(senderTitle: self.titleLabel.stringValue)
        self.closeDelegate.willClose?()
        
    }
    
    func setup(title: String, code: String) {
        
        self.loadView()
        self.titleLabel.stringValue = title
        self.textView.string = code
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}
