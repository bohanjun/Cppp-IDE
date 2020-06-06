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
    public static func CompileWithoutRunning(fileURL: String, arguments: String = compileConfig!.arguments ?? "") -> String {
         
        // The path of the file
        let _fileURL = "\"" + fileURL + "\""
        
        // Create The name of the output exec
        var out = (fileURL as NSString).deletingPathExtension as String
        out = "\"" + out + "\""
        
        // The compile command
        let command = "\(compileConfig!.compiler ?? "g++") \(arguments) \(_fileURL) -o \(out)"
        
        // Compile
        let b = shell(command)
        
        if b.count == 1 {
            // No error
            return "Compile Command:\n\(command)\n\nCompile Succeed"
            
        } else {
            // Have warning or error
            if b[1].range(of: "error") == nil {
                return "Compile Command:\n\(command)\n\nCompile Succeed\n\n" + b[1]
            }
            return "Compile Command:\n\(command)\n\nCompile Failed\n\n" + b[1]
            
        }
        
    }
    
}
