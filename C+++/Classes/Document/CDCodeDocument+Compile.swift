//
//  CDCodeDocument+Compile.swift
//  C+++
//
//  Created by 23786 on 2020/8/1.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

extension CDCodeDocument {
    
    @discardableResult
    func compileFile(alsoRuns: Bool = true, arguments: String = CDCompileSettings.shared.arguments) -> (result: String, didSuccess: Bool) {
        
        if self.fileURL == nil {
            self.contentViewController?.showAlert("Error", "You haven't saved your file yet. You must save your file before compiling it.")
            return (result: "", didSuccess: false)
        }
        
        let nsString = self.fileURL!.path.nsString
        
        let path = nsString.deletingLastPathComponent
         
        // The path of the file
        let _fileURL = "\"" + nsString.lastPathComponent + "\""
        
        // Create the name of the output exec
        let out = "\"" + nsString.lastPathComponent.nsString.deletingPathExtension + "\""
        
        // The compile command
        let command = "cd \"\(path)\"\n" + "\(CDCompileSettings.shared.compiler ?? "g++") \(arguments) \(_fileURL) -o \(out)"
        
        // Compile
        let compileResult = runShellCommand(command)
        
        var result = ""
        var didSuccess = false
        
        if compileResult.count == 1 {
            
            // Success
            result = "Compile Command:\n\n\(command)\n\nCompile Succeed"
            self.contentViewController?.setStatus(string: "\(self.fileURL!.lastPathComponent) | Compile Succeed")
            didSuccess = true
            
        } else {
            
            // Error
            if (compileResult[1].contains(" error: ")) {
                
                didSuccess = false
                self.contentViewController?.setStatus(string: "\(self.fileURL!.lastPathComponent) | Compile Failed")
                result = "Compile Command:\n\n\(command)\n\nCompile Failed\n\n" + compileResult[1]
                 
            } else /* Warning */ {
                
                didSuccess = true
                self.contentViewController?.setStatus(string: "\(self.fileURL!.lastPathComponent) | Compile Succeed")
                result = "Compile Command:\n\n\(command)\n\nCompile Succeed\n\n" + compileResult[1]
            }
            
        }
        
        result = result.replacingOccurrences(of: self.fileURL!.lastPathComponent + ":", with: "")
        
        if didSuccess {
            sendUserNotification(title: "Compile Succeed", subtitle: "\(self.fileURL!.lastPathComponent)")
        } else {
            sendUserNotification(title: "Compile Failed", subtitle: "\(self.fileURL!.lastPathComponent)")
        }
        
        if alsoRuns && didSuccess {
            let process = processForShellCommand(command: "cd \"\(path)\"\n" + "open \(out)")
            process.launch()
            self.contentViewController.currentRunningProcess = process
        }
        
        self.contentViewController?.consoleView?.textView?.string = result
            
        DispatchQueue.main.async {
            
            for i in result.components(separatedBy: "\n") {
                if i.first == nil {
                    continue
                }
                if i.first!.isNumber && i.contains(":") {
                    let index = i.firstIndexOf(":")
                    let nsstring = NSString(string: i)
                    let substring = nsstring.substring(to: index)
                    if let int = Int(substring) {
                        self.contentViewController?.lineNumberView?.buttonsArray[int - 1].markAsErrorLine()
                    }
                }
            }
            
        }
        
        return (result: result, didSuccess: didSuccess)
        
    }
    
    
    
    
    @IBAction func compileFile(_ sender: Any?) {
        
        self.compileFile(alsoRuns: true)
        
    }
    
    
    
    @IBAction func debugFile(_ sender: Any?) {
        
        self.contentViewController.presentAsSheet(CDFileCompiler.debugFile(fileURL: self.fileURL?.path ?? ""))
        
    }
    
    
    
    @IBAction func testFile(_ sender: Any?) {
        
        let vc = CDTestViewController()
        vc.fileURL = self.fileURL?.path ?? ""
        self.contentViewController.presentAsSheet(vc)
        
    }
    
    
    
    @IBAction func compileWithoutRunning(_ sender: Any?) {
        
        self.compileFile(alsoRuns: false)
        
    }
    
}
