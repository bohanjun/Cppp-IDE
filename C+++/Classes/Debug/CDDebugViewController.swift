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
    var inputPipe: Pipe = Pipe()
    
    public func setFilePath(path: String) {
        self.filePath = path
    }
    
    @IBAction func end(_ sender: Any?) {
        if task?.isRunning ?? false {
            task.suspend()
        }
        self.dismiss(self)
    }
    
    @IBAction func start(_ sender: Any?) {
        
        /*let compileRes = CDFileCompiler.compileFileWithoutRunning(fileURL: self.filePath, arguments: "-g")
        if compileRes.contains("Compile Failed") {
            self.textView.string = "Compile Failed. Please check your code carefully and try again.\n\n\(compileRes)"
            return
        }*/
        
        task = Process()
        task.launchPath = "/bin/bash"
        task.arguments = ["-c", "lldb \"\(filePath.nsString.deletingPathExtension)\""]
        
        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardInput = inputPipe
        let outHandle = pipe.fileHandleForReading
        
        outHandle.readabilityHandler = { pipe in
            
            if let line = String(data: pipe.availableData, encoding: String.Encoding.utf8) {
                DispatchQueue.main.async {
                    self.textView.isEditable = true
                    self.textView.string.append(line)
                    self.textView.isEditable = false
                }
            } else {
                print("Error decoding data: \(pipe.availableData)")
            }
            
        }
        
        task.launch()
        
    }
    
    func send(message: String) {
        
        inputPipe.fileHandleForWriting.write(message.data(using: .utf8)!)
        
    }
    
    @IBAction func sendMessage(_ sender: Any?) {
        
        send(message: textField.stringValue + "\n")
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.textView.font = menloFont(ofSize: 13.0)
        
    }
    
    
    @IBAction func run(_ sender: Any) {
        self.textField.stringValue = "run"
        sendMessage(sender)
    }
    
    @IBAction func next(_ sender: Any) {
        self.textField.stringValue = "next"
        sendMessage(sender)
    }
    
    @IBAction func step(_ sender: Any) {
        self.textField.stringValue = "step"
        sendMessage(sender)
    }
    
    @IBAction func finish(_ sender: Any) {
        self.textField.stringValue = "finish"
        sendMessage(sender)
    }
    
    @IBAction func `continue`(_ sender: Any) {
        self.textField.stringValue = "continue"
        sendMessage(sender)
    }
    
    @IBAction func viewVariables(_ sender: Any) {
        self.textField.stringValue = "frame variable"
        sendMessage(sender)
    }
    
    
}
