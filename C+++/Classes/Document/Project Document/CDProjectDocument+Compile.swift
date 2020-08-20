//
//  CDProjectDocument+Compile.swift
//  C+++
//
//  Created by 23786 on 2020/8/19.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

extension CDProjectDocument {
    
    @IBAction func compile(_ sender: Any?) {
        self.contentViewController.log.string = "- " + compileProject().output.joined(separator: "\n\n- ")
    }
    
    func compileProject() -> (didSuccess: Bool, output: [String]) {
        
        if self.fileURL == nil {
            self.contentViewController.showAlert("Error", "Please save your project first.")
        }
        
        
        // MARK: - Variables
        
        var output = [String]()
        var didSuccess = true
        let cd = "cd \"\(self.fileURL!.path.nsString.deletingLastPathComponent)\"\n"
        Swift.print("cd = \(cd)")
        
        func _runCommand(_ command: String) -> [String] {
            return runShellCommand("\(cd)\(command)")
        }
        
        
        
        // MARK: - Create Build Directory
        let compileFolderPath = self.fileURL!.deletingLastPathComponent().appendingPathComponent("Build").path
        
        output.append("Creating build directory...")
        
        if !FileManager.default.fileExists(atPath: compileFolderPath) {
            
            do {
                try FileManager.default.createDirectory(atPath: compileFolderPath, withIntermediateDirectories: true)
                output.append("Create directory succeed.")
            } catch {
                self.contentViewController.showAlert("Error", "The build directory cannot be created. (1)")
                output.append("Error: The build directory cannot be created. (1)")
                return (didSuccess: false, output: output)
            }
            
        } else {
            
            output.append("Build directory already exsists.")
            
        }
        
        NSLog("Build Directory Created")
        
        // MARK: - Compile .o File
        
        var allCFilePaths = [String]()
        var allCppFilePaths = [String]()
        
        // Recursive
        func viewAllDocuments(_ current: CDProjectItem) {
            
            switch current {
                
                case .document(let document):
                    if ["c"].contains(document.path.nsString.pathExtension) {
                        NSLog("C++: %@", document.path)
                        allCFilePaths.append(document.path)
                    }
                    if ["cpp", "cxx", "c++"].contains(document.path.nsString.pathExtension) {
                        NSLog("C++ File: %@", document.path)
                        allCppFilePaths.append(document.path)
                    }
                    
                case .project(let project):
                    for i in project.children {
                        viewAllDocuments(i)
                    }
                    
                case .folder(let folder):
                    for i in folder.children {
                        viewAllDocuments(i)
                    }
                    
            }
            
        }
        
        output.append("Viewing all files...")
        
        viewAllDocuments(.project(self.project ?? CDProject(compileCommand: "", version: "")))
        
        output.append("End.")
        
        
        var objectFiles = [String]()
        
        
        // MARK: C
        
        for path in allCFilePaths {
            
            if let outputPath = compileFolderPath.nsString.appendingPathComponent(path.nsString.lastPathComponent).nsString.appendingPathExtension("o") {
                
                let res = _runCommand("gcc -c \"\(path)\" -o \"\(outputPath)\"")
                
                switch res.count {
                    case 1:
                        output.append("Compile \(path.nsString.lastPathComponent) (gcc): Succeed.")
                        objectFiles.append("\"./Build/" + outputPath + "\"")
                        
                    case 2:
                        output.append("Compile \(path.nsString.lastPathComponent) (gcc): Failed.\nError: \(res[1])")
                        if res[1].contains("error") {
                            didSuccess = false
                        } else {
                            output.append("Compile \(path.nsString.lastPathComponent) (gcc): Succeed.\nCompiler Output: \(res[1])")
                            
                            objectFiles.append("\"./Build/" + outputPath + "\"")
                        }
                        
                    default:
                        self.contentViewController.showAlert("Error", "Unknown Error. Array length invalid. (3)")
                        output.append("Unknown Error. Array length invalid. (3)")
                        return (false, output)
                }
                
            } else {
                
                self.contentViewController.showAlert("Error", "The output file directory cannot be created. (2, file: \(path)")
                output.append("The output file directory cannot be created. (2, file: \(path)")
                return (didSuccess: false, output)
                
            }
            
            
        }
        
        // MARK: C++
        
        for path in allCppFilePaths {
            
            if let outputPath =
                path.nsString.lastPathComponent.nsString.appendingPathExtension("o") {
                
                Swift.print("\(cd)g++ -c \"\(path)\" -o \"./Build/\(outputPath)\"")
                let res = _runCommand("g++ -c \"\(path)\" -o \"./Build/\(outputPath)\"")
                
                switch res.count {
                    
                    case 1:
                        output.append("Compile \(path.nsString.lastPathComponent) (g++): Succeed.")
                        objectFiles.append("\"./Build/" + outputPath + "\"")
                        
                    case 2:
                        output.append("Compile \(path.nsString.lastPathComponent) (g++): Failed.\nError: \(res[1])")
                        if res[1].contains("error") {
                            didSuccess = false
                        } else {
                            output.append("Compile \(path.nsString.lastPathComponent) (g++): Succeed.\nCompiler Output: \(res[1])")
                            objectFiles.append("\"./Build/" + outputPath + "\"")
                        }
                        
                    default:
                        self.contentViewController.showAlert("Error", "Unknown Error. Array length invalid. (3)")
                        output.append("Unknown Error. Array length invalid. (3)")
                        return (false, output)
                        
                }
                
            } else {
                
                self.contentViewController.showAlert("Error", "The output file directory cannot be created. (2, file: \(path)")
                output.append("The output file directory cannot be created. (2, file: \(path)")
                return (didSuccess: false, output)
                
            }
            
            
        }
        
        // MARK: Compile Executable File
        
        guard didSuccess else {
            output.append("Compile Failed.")
            return (didSuccess, output)
        }
        
        let command = "g++ \(objectFiles.joined(separator: " ")) -o \"./Build/\(self.fileURL!.path.nsString.lastPathComponent.nsString.deletingPathExtension)\""
        
        NSLog("Compile Command: %@", command)
        
        output.append("Compile Command: \(command)")
        output.append("Begin Compiling...")
        
        let res = _runCommand(command)
        
        switch res.count {
            
            case 1:
                output.append("Compile Succeed.")
                NSLog("Compile Succeed")
            case 2:
                output.append("Compile Failed.\nError: \(res[1])")
                NSLog("Compile Failed")
                didSuccess = false
            default:
                self.contentViewController.showAlert("Error", "Unknown Error. Array length invalid. (3)")
                output.append("Unknown Error. Array length invalid. (3)")
                return (false, output)
                
        }
        
        return (didSuccess, output)
        
    }
    
}
