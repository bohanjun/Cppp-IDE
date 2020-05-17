//
//  DefaultCode.swift
//  Code Editor
//
//  Created by 23786 on 2020/5/4.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

/*import Cocoa

class DefaultCode: NSObject, NSCoding {
    
    // MARK: - Properties
    
    var code: String!
    
    // MARK: - Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .libraryDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("C+++").appendingPathComponent("DefaultCode")
    
    
    // MARK: - Initialization
    
    init?(_ code: String?) {
        
        self.code = code
        
    }
    
    
    // MARK: - NSCoding
    
    func encode(with coder: NSCoder) {
        coder.encode(code, forKey: "Code")
    }
    
    required convenience init?(coder: NSCoder) {
        
        let code = coder.decodeObject(forKey: "Code") as? String
        self.init(code)
        
    }
    
}
*/
