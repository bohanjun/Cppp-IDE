//
//  CDDebugView.swift
//  C+++
//
//  Created by 23786 on 2020/5/10.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

class CDDebugViewController: NSViewController {
    
    @IBOutlet var textView: NSTextView!
    @IBOutlet weak var textField: NSTextField!
    var task: Process!
    var filePath: String!
    
    public func setFilePath(path: String) {
        self.filePath = path
    }
    
    @IBAction func end(sender: Any?) {
        if task?.isRunning ?? false {
            task.suspend()
        }
        self.dismiss(self)
    }
    
    @IBAction func start(sender: Any?) {
        
        let compileRes = CDFileCompiler.CompileWithoutRunning(fileURL: self.filePath)
        if compileRes.contains("Compile Failed") {
            self.textView.string = "Compile Failed. Please check your code carefully and try again.\n\n\(compileRes)"
            return
        }
        
        task = Process()
        task.launchPath = "/bin/bash"
        task.arguments = ["-c", "lldb \((filePath as NSString).deletingPathExtension)"]
        
        let pipe = Pipe()
        task.standardOutput = pipe
        let outHandle = pipe.fileHandleForReading
        
        outHandle.readabilityHandler = { pipe in
            
            if let line = String(data: pipe.availableData, encoding: String.Encoding.utf8) {
                self.textView.insertText(line, replacementRange: self.textView.selectedRange)
            } else {
                print("Error decoding data: \(pipe.availableData)")
            }
            
        }
        
        task.launch()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}
