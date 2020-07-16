//
//  CDFileCompiler(Compile).swift
//  C+++
//
//  Created by 23786 on 2020/5/11.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

extension CDFileCompiler {
    
    /** Compile a C++ source file without running.
    - parameter fileURL: The path of the file.
    - returns: The result to be displayed in the "Compile Info"  text view.
    */
    public static func compileFileWithoutRunning(fileURL: String, arguments: String = CDCompileSettings.shared.arguments ?? "") -> String {
         
        let path = fileURL.nsString.deletingLastPathComponent
         
        // The path of the file
        let _fileURL = "\"" + fileURL.nsString.lastPathComponent + "\""
        
        // Create the name of the output exec
        let out = "\"" + fileURL.nsString.lastPathComponent.nsString.deletingPathExtension + "\""
        
        // The compile command
        let command = "\(CDCompileSettings.shared.compiler ?? "g++") \(arguments) \(_fileURL) -o \(out)"
        
        // Compile
        let compileResult = shell("cd \"\(path)\"\n" + command)
        
        if compileResult.count == 1 {
            
            // No error
            return "Compile Command:\n\ncd \"\(path)\"\n\(command)\n\nCompile Succeed"
            
        } else {
            
            // Have warning or error
            if !(compileResult[1].contains(" error: ")) {
                
                return "Compile Command:\n\ncd \"\(path)\"\n\(command)\n\nCompile Succeed\n\n" + compileResult[1]
                 
            }
            
            return "Compile Command:\n\ncd \"\(path)\"\n\(command)\n\nCompile Failed\n\n" + compileResult[1]
            
        }
        
    }
    
}
