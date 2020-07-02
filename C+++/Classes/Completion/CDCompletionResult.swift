//
//  CDParser.swift
//  C+++
//
//  Created by 23786 on 2020/5/8.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

class CDCompletionResult: NSObject {
    
    init(returnType: String?, typedText: String, otherTexts: [String]) {
        super.init()
        
        self.returnType = returnType
        self.typedText = typedText
        self.otherTexts = otherTexts
        
    }
    
    var returnType: String!
    var typedText = ""
    var otherTexts = [String]()
    
    var hasReturnType: Bool {
        return returnType != nil
    }
    
    var textForDisplay: String {
        if self.hasReturnType {
            return "(" + self.returnType + ") " + self.typedText + self.otherTexts.joined()
        } else {
            return self.typedText + self.otherTexts.joined(separator: "")
        }
    }
    
    var completionString: String {
        return self.typedText + self.otherTexts.joined(separator: "")
    }
        
}
