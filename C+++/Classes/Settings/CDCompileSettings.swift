//
//  CompileSettings.swift
//  Code Editor
//
//  Created by apple on 2020/4/17.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

class CDCompileSettings: NSObject, NSCoding {
    
    var compiler: String!
    var arguments: String!
    
    static let DocumentsDirectory = FileManager().urls(for: .libraryDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("C+++").appendingPathComponent("CompileSettings")
    
    struct PropertyKey {
        static let Compiler = "Compiler"
        static let Arguments = "Arguments"
    }
    
    init?(_ compiler: String?, _ arguments: String?) {
        self.compiler = compiler
        self.arguments = arguments
    }
    
    
    func encode(with coder: NSCoder) {
        coder.encode(compiler, forKey: PropertyKey.Compiler)
        coder.encode(arguments, forKey: PropertyKey.Arguments)
    }
    
    required convenience init?(coder: NSCoder) {
        let compiler = coder.decodeObject(forKey: PropertyKey.Compiler) as? String
        let arguments = coder.decodeObject(forKey: PropertyKey.Arguments) as? String
        
        self.init(compiler, arguments)
    }
    
}
