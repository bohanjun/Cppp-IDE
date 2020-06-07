//
//  CDParser.swift
//  C+++
//
//  Created by 23786 on 2020/5/8.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

extension Array where Element: Equatable {
        
    func removeDuplicate() -> Array {
            
        return self.enumerated().filter { (index,value) -> Bool in
            return self.firstIndex(of: value) == index
        }.map { (_, value) in
                value
        }
        
    }
    
}

class CDParser: NSObject {
    
    init(code: String) {
        super.init()
        
        self.buffer = code
        
    }
    
    private let keywords: [String] = [
         "if", "else", "while", "signed", "throw", "union", "this",
         "int", "char", "double", "unsigned", "const", "goto", "virtual",
          "for", "float", "break", "auto", "class", "operator", "case",
          "do", "long", "typedef", "static", "friend", "template", "default",
          "new", "void", "register", "extern", "return", "enum", "inline",
          "try", "short", "continue", "sizeof", "switch", "private", "protected",
          "asm", "catch", "delete", "public", "voltaile", "struct", "using",
          "namespace", "bool", "main", "true", "false"
    ];

    var buffer: String!
    var pos: Int = -1
    
    private var state: ParserResult = .all
    
    private enum ParserResult : Int {
        
        case all = 0
        case divide = 4
        case singleLineComment = 20
        case multipleLineComment = 21
        case multipleLineComment2 = 22
        case multipleLineComment3 = 23
        case stringStart = 16
        case letter = 18
        case keyword = 29
        case whiteSpace = 31
        case preprocessor = 32
        case end = 100
        case fileEnd = 101
        case otherSymbol = 99
        
    }
    

    func back() {
        pos -= 1
    }
    
    func getNext() -> Character? {
        
        if pos + 1 < buffer.count {
            pos += 1
            return Array(buffer)[pos]
        } else {
            return "\0"
        }
        
    }
    
    func getIdentifiers() -> [String] {
        
        pos = -1
        state = .all
        
        let startTime = Date()

        var res: [String] = []
        
        var ch: Character = " "
        var token: String = ""
        
        while true {
            
            if let c = getNext() {
                ch = c
            } else {
                break
            }
            
            while state != .end {
                
                switch state {
                    
                    case .all :
                        
                    switch ch {
                        
                        case "+", "-", "*", "<", ">", "=", ";", "!", "[", "]", "(", ")", "{", "}", ",", ".", "&":
                            state = .otherSymbol
                        case "\"": state = .stringStart
                        case "#": state = .preprocessor
                        case "/": state = .divide
                        case "\0": state = .fileEnd
                        
                        default:
                        if ch.isLetter {
                            state = .letter
                        } else if ch.isWhitespace {
                            state = .whiteSpace
                        } else {
                            state = .otherSymbol
                        }
                        
                    }
                    
                    case .otherSymbol:
                        ch = getNext()!
                        state = .end
                    
                    case .preprocessor:
                        token.append(ch)
                        ch = getNext()!
                        if ch == "\n" {
                            state = .otherSymbol
                        } else if ch == "\0" {
                            state = .fileEnd
                        } else {
                            state = .preprocessor
                        }
                    
                    case .whiteSpace:
                        ch = getNext()!
                        if ch.isWhitespace {
                            state = .whiteSpace
                        } else {
                            state = .all
                        }
                    
                    case .divide:
                        ch = getNext()!
                        if ch == "/" {
                            state = .singleLineComment
                        } else if ch == "*" {
                            state = .multipleLineComment
                        } else {
                            ch = getNext()!
                            state = .end
                        }
                    
                    case .singleLineComment:
                        while let c = getNext() {
                            if c == "\n" {
                                ch = c
                                break
                            }
                        }
                        state = .end
                    
                    case .multipleLineComment:
                        ch = getNext()!
                        if ch == "*" {
                            state = .multipleLineComment2
                        } else {
                            state = .multipleLineComment
                        }
                    
                    case .multipleLineComment2:
                        ch = getNext()!
                        if ch == "*" {
                            state = .multipleLineComment2
                        } else if ch == "/" {
                            state = .multipleLineComment3
                        } else {
                            state = .multipleLineComment
                        }
                    
                    case .multipleLineComment3:
                        state = .end
                        ch = getNext()!
                    
                    case .stringStart:
                        ch = getNext()!
                        if ch == "\"" {
                            state = .otherSymbol
                        } else {
                            state = .stringStart
                        }
                    
                    case .letter:
                        token.append(ch)
                        ch = getNext()!
                        if ch.isLetter || ch.isNumber {
                            state = .letter
                        } else {
                            back()
                            state = .keyword
                        }
                        
                    case .keyword:
                        if keywords.contains(token) {
                            state = .otherSymbol
                        } else {
                            state = .end
                            res.append(token)
                        }
                    
                    
                    case .end, .fileEnd: break
                    
                }
                
                if state == .end {
                    token = ""
                    state = .all
                }
                
                if state == .fileEnd {
                    break
                }
                    
            }
            
            if state == .fileEnd {
                break
            }
                
        }
        
        print("Time: ", -startTime.timeIntervalSinceNow)
        
        return res.removeDuplicate()
        
    }
        
}
