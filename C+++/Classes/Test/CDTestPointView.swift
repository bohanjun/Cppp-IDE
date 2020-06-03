//
//  CDTestPointView.swift
//  C+++
//
//  Created by 23786 on 2020/6/3.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

@IBDesignable
class CDTestPointView: NSView {
    
    @IBOutlet weak var inputTextView: NSTextView!
    @IBOutlet weak var outputTextView: NSTextView!
    @IBOutlet weak var actualOutputTextView: NSTextView!
    @IBOutlet weak var checkBox: NSButton!
    
    var input: String? {
        return inputTextView?.string
    }
    
    var output: String? {
        return outputTextView?.string
    }
    
    var actualOutput: String? {
        get {
            return actualOutputTextView?.string
        }
        set {
            actualOutputTextView?.string = newValue ?? "Error"
        }
    }
    
    var isEnabled: Bool {
        get {
            return checkBox?.state == .on
        } set {
            if newValue {
                checkBox?.state = .on
                inputTextView?.isHidden = false
                outputTextView?.isHidden = false
                actualOutputTextView?.isHidden = false
            } else {
                checkBox?.state = .off
                inputTextView?.isHidden = true
                outputTextView?.isHidden = true
                actualOutputTextView?.isHidden = true
            }
        }
    }
    
    @IBAction func didChange(_ sender: Any?) {
        
        switch self.checkBox.state {
            case .on:
                self.isEnabled = true
            default:
                self.isEnabled = false
        }
        
    }
    
}
