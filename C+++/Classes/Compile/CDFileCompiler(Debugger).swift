//
//  FileCompiler(Debugger).swift
//  C+++
//
//  Created by 23786 on 2020/5/10.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

extension CDFileCompiler {
    
    public static func debugFile(fileURL: String) -> CDDebugViewController {
        
        let vc = CDDebugViewController()
        vc.setFilePath(path: fileURL)
        return vc
        
        
    }
    
}
