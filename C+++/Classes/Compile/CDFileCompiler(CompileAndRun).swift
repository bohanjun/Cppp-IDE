//
//  Compile.swift
//  C+++
//
//  Created by apple on 2020/3/22.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

class CDFileCompiler: NSObject {
    
    /** Compile a C++ source file.
    - parameter fileURL: The path of the file.
    - returns: The result to be displayed in the "Compile Info"  text view.
    */
    public static func compileFile(fileURL: String, arguments: String = CDCompileSettings.shared.arguments ?? "") -> String {
        
        let path = (fileURL as NSString).deletingLastPathComponent
         
        // The path of the file
        let _fileURL = "\"" + (fileURL as NSString).lastPathComponent + "\""
        
        // Create the name of the output exec
        let out = "\"" + (((fileURL as NSString).lastPathComponent as NSString).deletingPathExtension) + "\""
        
        // The compile command
        let command = "\(CDCompileSettings.shared.compiler ?? "g++") \(arguments) \(_fileURL) -o \(out)"
        
        // Compile
        let compileResult = shell("cd \"\(path)\"\n" + command)
        
        if compileResult.count == 1 {
            
            // No error
            shell("cd \"\(path)\"\n" + "open \(out)")
            return "Compile Command:\n\ncd \"\(path)\"\n\(command)\n\nCompile Succeed"
            
        } else {
            
            // Have warning or error
            if !(compileResult[1].contains(" error: ")) {
                
                shell("cd \"\(path)\"\n" + "open \(out)")
                return "Compile Command:\n\ncd \"\(path)\"\n\(command)\n\nCompile Succeed\n\n" + compileResult[1]
                 
            }
            
            return "Compile Command:\n\ncd \"\(path)\"\n\(command)\n\nCompile Failed\n\n" + compileResult[1]
            
        }
        
    }

    /** Run a shell command.
     - parameter command: The command.
     - parameter stdin: The stantard input.
     - returns: If no error ocurred, return a string array with only one item (stantard output).
       If an error ocurred, return a string array with two items (stantard output and stantard error).
    */
    @discardableResult
    static func shell(_ command: String, _ stdin: String = "") -> [String] {
        
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
    
}

