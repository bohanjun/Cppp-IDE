//
//  CDCompletionResult.swift
//  C+++
//
//  Created by 23786 on 2020/5/8.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa


class CDCompletionResult: NSObject {
    
    var type: ResultType = .other
    var matchedRanges = [NSRange]()
    
    enum ResultType: Int {
        
        case `enum` = 0x00
        case namespace = 0x01
        case `typealias` = 0x02
        case `struct` = 0x03
        case `class` = 0x04
        case function = 0x05
        case variable = 0x06
        case preprocessing = 0x07
        case other = 0xFF
        
        static func resultType(forCKCursorKind kind: CKCursorKind) -> ResultType {
            
            switch kind {
                
                case CKCursorKindEnumDecl, CKCursorKindEnumConstantDecl: return .enum
                case CKCursorKindFunctionDecl, CKCursorKindFunctionTemplate, CKCursorKindConversionFunction, CKCursorKindCXXFunctionalCastExpr: return .function
                case CKCursorKindNamespace, CKCursorKindNamespaceRef, CKCursorKindNamespaceAlias: return .namespace
                case CKCursorKindVarDecl, CKCursorKindVariableRef: return .variable
                case CKCursorKindStructDecl: return .struct
                case CKCursorKindClassDecl: return .class
                case CKCursorKindMacroExpansion, CKCursorKindMacroDefinition, CKCursorKindMacroInstantiation, CKCursorKindLastPreprocessing, CKCursorKindFirstPreprocessing, CKCursorKindPreprocessingDirective: return .preprocessing
                case CKCursorKindTypeAliasDecl, CKCursorKindTypedefDecl: return .typealias
                
                default: return .other
            
            }
            
        }
        
    }
    
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
        return self.typedText + self.otherTexts.joined()
    }
    
    var attributedString: NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self.textForDisplay, attributes: [.font: NSFont(name: CDSettings.shared.fontName ?? "Menlo", size: 14.0)!])
        for i in self.matchedRanges {
            attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: i)
        }
        return attributedString
    }
    
    var image: NSImage? {
        
        switch self.type {
            case .class: return NSImage(named: "Class")
            case .enum: return NSImage(named: "Enum")
            case .function: return NSImage(named: "Function")
            case .namespace: return NSImage(named: "Namespace")
            case .preprocessing: return NSImage(named: "Preprocessing")
            case .typealias: return NSImage(named: "Typealias")
            case .struct: return NSImage(named: "Struct")
            case .variable: return NSImage(named: "Variable")
            default: return nil
        }
        
    }
    
    var completionString: String {
        return self.typedText + self.otherTexts.joined(separator: "")
    }
        
}
