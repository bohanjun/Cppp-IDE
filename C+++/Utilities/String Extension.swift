//
//  String Extension.swift
//  C+++
//
//  Created by 23786 on 2020/7/16.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

extension String {
    
    var nsString: NSString {
        return NSString(string: self)
    }
    
    /// Count how many times a character appears in a string.
    /// - Parameter character: The character.
    /// - Returns: How many times the character appears in the string.
    func challenge(_ character: Character) -> Int {
        Array(self).reduce(0, {$1 == character ? $0 + 1 : $0})
    }
    
    /// Get the number of the line which the character at a specific position is in.
    /// - Parameter position: The position.
    /// - Returns: The number of the line which the character at `position` is in.
    func lineNumber(at position: Int) -> Int? {
        
        var lineNumber = 0
        var characterPosition = 0
        for line in self.components(separatedBy: .newlines) {
            lineNumber += 1
            for _ in line {
                characterPosition += 1
                if characterPosition == position {
                    return lineNumber
                }
            }
            characterPosition += 1
            if characterPosition == position {
                return lineNumber
            }
        }
        return 1
        
    }
    
    func columnNumber(at position: Int) -> Int {
        
        var columnNumber = 0
        var characterPosition = 0
        for line in self.components(separatedBy: .newlines) {
            columnNumber = 0
            for _ in line {
                characterPosition += 1
                columnNumber += 1
                if characterPosition == position {
                    return columnNumber
                }
            }
            characterPosition += 1
            columnNumber += 1
            if characterPosition == position {
                return columnNumber
            }
        }
        return 1
        
    }
    
    var isIdentifier: Bool {
        get {
            if self.count == 0 {
                return true
            }
            if !(Array(self)[1].isLetter || Array(self)[1] == "_") {
                return false
            }
            for (i, char) in Array(self).enumerated() {
                if i == 0 {
                    continue
                }
                if !(char.isLetter || char.isNumber || char == "_") {
                    return false
                }
            }
            return true
        }
    }
    
    /// Returns the index of the first substring in the string.
    /// - Parameters:
    ///   - string: The substring.
    /// - Returns: The index of the first substring in the string. -1 if not found.
    func firstIndexOf(_ string: String) -> Int {
        
        var pos = -1
        if let range = range(of: string, options: .literal) {
            if !range.isEmpty {
                pos = self.distance(from: startIndex, to: range.lowerBound)
            }
        }
        return pos
        
    }
    
    func compareWith(anotherString string: String) -> (string: String, range: [NSRange]) {
        var str1 = "", str2 = ""
        var range = [NSRange]()
        var resultString = ""
        // str1 is shorter.
        if string.count >= self.count {
            str1 = self
            str2 = string
        } else {
            str1 = string
            str2 = self
        }
        let array1 = Array(str1), array2 = Array(str2)
        var index = 0, index2 = 0
        for char in array1 {
            for i in index2..<array2.count {
                if array2[i] == char {
                    range.append(NSMakeRange(index2, 1))
                    resultString.append(char)
                    index2 += 1
                    break
                }
                index2 += 1
            }
            index += 1
        }
        return (string: resultString, range: range)
    }

}
