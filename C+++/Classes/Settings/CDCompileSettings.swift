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
    
    static let documentsDirectory = FileManager().urls(for: .libraryDirectory, in: .userDomainMask).first!
    static let archiveURL = documentsDirectory.appendingPathComponent("C+++").appendingPathComponent("CompileSettings")
    
    struct PropertyKey {
        static let compiler = "Compiler"
        static let arguments = "Arguments"
    }
    
    init?(_ compiler: String?, _ arguments: String?) {
        self.compiler = compiler
        self.arguments = arguments
    }
    
    
    func encode(with coder: NSCoder) {
        coder.encode(compiler, forKey: PropertyKey.compiler)
        coder.encode(arguments, forKey: PropertyKey.arguments)
    }
    
    required convenience init?(coder: NSCoder) {
        let compiler = coder.decodeObject(forKey: PropertyKey.compiler) as? String
        let arguments = coder.decodeObject(forKey: PropertyKey.arguments) as? String
        
        self.init(compiler, arguments)
        
    }
    
}
