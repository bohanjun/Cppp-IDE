//
//  Compile.swift
//  C+++
//
//  Created by apple on 2020/3/22.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

public func CompileSource(_ folderPath: String, fileURL: String, stdin: String, openInTerminal: Bool) -> [String] {
    
    
    let _folderPath = "\"" + folderPath + "\""
    let _fileURL = "\"" + fileURL + "\""
    
    shell("cd \(_folderPath)", "")
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
    
    var command: String
    if openInTerminal {
        command = "\(compileConfig.Compiler ?? "g++") \(compileConfig.Arguments ?? "") \(_fileURL) -o \(out)"
    } else {
        command = "\(compileConfig.Compiler ?? "g++") \(compileConfig.Arguments ?? "") \(_fileURL)"
    }
    
    let b = shell(command, "")
    
    if b.count == 1 {
        var c: [String]
        if openInTerminal {
            c = shell("open \(out)", stdin)
        } else {
            c = shell("./a.out", stdin)
        }
        return ["Compile Command:\n\(command)\n\nCompile Succeed", c[0]]
        
    } else {
        
        if b[1].range(of: "error") == nil {
            
            var c: [String]
            if openInTerminal {
                c = shell("open \(out)", stdin)
            } else {
                c = shell("./a.out", stdin)
            }
            return [b[1], c[0]]
        }
        
        return [b[1], "Compile Command:\n\(command)\n\nCompile Failed"]
        
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


