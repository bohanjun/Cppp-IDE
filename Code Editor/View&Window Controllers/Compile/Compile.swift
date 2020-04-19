//
//  Compile.swift
//  C+++
//
//  Created by apple on 2020/3/22.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

public func CompileSource(fileURL: String) -> String {
    
    // The path of the file
    let _fileURL = "\"" + fileURL + "\""
    
    // Create The name of the output exec
    var out = fileURL
    if out.hasSuffix(".cpp") {
        for _ in 1...4 {
            out.removeLast()
        }
    } else if out.hasSuffix(".c") || out.hasSuffix(".h") {
        out.removeLast()
        out.removeLast()
    }
    out = "\"" + out + "-output\""
    
    // The compile command
    let command = "\(compileConfig.Compiler ?? "g++") \(compileConfig.Arguments ?? "") \(_fileURL) -o \(out)"
    
    // Compile
    let b = shell(command, "")
    
    if b.count == 1 {
        // No error
        shell("open \(out)", "")
        return "Compile Command:\n\(command)\n\nCompile Succeed"
        
    } else {
        // Have warning or error
        if b[1].range(of: "error") == nil {
            
            shell("open \(out)", "")
            return "Compile Command:\n\(command)\n\nCompile Succeed\n\n" + b[1]
        }
        
        return "Compile Command:\n\(command)\n\nCompile Failed\n\n" + b[1]
        
    }
    
}

@discardableResult
fileprivate func shell(_ command: String, _ stdin: String) -> [String] {
    
    let task = Process()
    task.launchPath = "/bin/bash"
    task.arguments = ["-c", command]
    
    let pipe = Pipe()
    let errorPipe = Pipe()
    let inputPipe = Pipe()
    inputPipe.fileHandleForWriting.write(stdin.data(using: .utf8)!)
    
    task.standardOutput = pipe
    task.standardError = errorPipe
    task.standardInput = inputPipe
    task.launch()
    
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output: String = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
    
    let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
    let errorOutput: String = NSString(data: errorData, encoding: String.Encoding.utf8.rawValue)! as String
    
    
    if errorOutput == "" {
        return [output]
    }
    return [output, errorOutput]
    
}


