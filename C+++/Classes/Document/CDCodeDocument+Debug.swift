//
//  CDCodeDocument+Debug.swift
//  C+++
//
//  Created by 23786 on 2020/8/1.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

extension CDCodeDocument {
    
    func beginDebugging() {
        
        let res = self.compileFile(alsoRuns: false, arguments: "-g")
        if !res.didSuccess {
            self.contentViewController?.showAlert("Warning", "Compilation failed. Please check your code.")
            return
        }
        self.contentViewController?.consoleView?.textView?.string = "Begin Debugging\n\nBegin Compiling: \(res.result)\n\n=====================\n\nLLDB Process Launched\n\n\n"
        
        task = Process()
        task.launchPath = "/bin/bash"
        task.arguments = ["-c", "lldb \"\(self.fileURL!.path.nsString.deletingPathExtension)\""]
        
        let pipe = Pipe()
        self.inputPipe = Pipe()
        task.standardOutput = pipe
        task.standardInput = inputPipe
        let outHandle = pipe.fileHandleForReading
        
        outHandle.readabilityHandler = { pipe in
            
            if let line = String(data: pipe.availableData, encoding: .utf8) {
                if line != "" {
                    DispatchQueue.main.async {
                        self.contentViewController?.consoleView?.textView?.string.append(line)
                    }
                }
            } else {
                Swift.print("Error decoding data: \(pipe.availableData)")
            }
            
        }
        
        task.launch()
        
        for i in self.contentViewController.lineNumberView.debugLines {
            Swift.print("i=\(i)")
            self.sendInputToDebugger(message: "breakpoint set --line \(i)")
        }
        
    }
    
    func sendInputToDebugger(message: String) {
        self.inputPipe?.fileHandleForWriting.write((message + "\n").data(using: .utf8)!)
    }
    
    
    
    @IBAction func beginDebugging(_ sender: Any?) {
        self.beginDebugging()
    }
    
}
