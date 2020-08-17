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
        
        // If there is already a lldb process, terminate it.
        self.endDebugging()
        
        if self.fileURL == nil {
            self.contentViewController?.showAlert("Error", "You haven't saved your file yet. You must save your file before debugging it.")
            return
        }
        
        let res = self.compileFile(alsoRuns: false, arguments: "-g")
        if !res.didSuccess {
            self.contentViewController?.showAlert("Warning", "Compilation failed. Please check your code.")
            return
        }
        self.contentViewController?.consoleView?.textView?.string = "Begin Debugging\n\nBegin Compiling: \(res.result)\n\n\n\nLLDB Process Launched\n\n\n"
        
        debugTask = Process()
        debugTask.launchPath = "/bin/bash"
        debugTask.arguments = ["-c", "lldb \"\(self.fileURL!.path.nsString.deletingPathExtension)\""]
        self.contentViewController.setStatus(string: "Preparing for Debugging...")
        
        let pipe = Pipe()
        self.debugInputPipe = Pipe()
        debugTask.standardOutput = pipe
        debugTask.standardInput = debugInputPipe
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
        
        debugTask.launch()
        
        self.contentViewController.setStatus(string: "Setting Breakpoint...")
        
        for i in self.contentViewController.lineNumberView.debugLines {
            self.sendInputToDebugger(message: "breakpoint set --line \(i)")
        }
        
        self.contentViewController.setStatus(string: "\(self.fileURL?.lastPathComponent ?? "C+++") | Debugging")
        
    }
    
    func sendInputToDebugger(message: String) {
        if debugTask.isRunning {
            self.debugInputPipe?.fileHandleForWriting.write((message + "\n").data(using: .utf8)!)
            if message.trimmingCharacters(in: .whitespacesAndNewlines) == "q" || message.trimmingCharacters(in: .whitespacesAndNewlines) == "quit" {
                self.contentViewController.setStatus(string: "\(self.fileURL?.lastPathComponent ?? "C+++") | Finished Debugging")
            }
        } else {
            debugInputPipe = nil
        }
    }
    
    
    
    @IBAction func beginDebugging(_ sender: Any?) {
        self.beginDebugging()
    }
    
    func endDebugging() {
        self.debugTask?.terminate()
        self.contentViewController.setStatus(string: "\(self.fileURL?.lastPathComponent ?? "C+++") | Finished Debugging")
    }
    
}
