////
////  CDParser.swift
////  C+++
////
////  Created by 23786 on 2020/8/8.
////  Copyright © 2020 Zhu Yixuan. All rights reserved.
////
//
//import Cocoa
//
//class CDParser: NSObject {
//
//    static func deleteCodeComment(_ code: String) -> String {
//
//        let lines = code.components(separatedBy: "\n")
//
//        var newSource = ""
//        var inBlock = false
//        var replaceFlag = false
//
//        for line in lines {
//            if line.count == 0 {
//                continue;
//            }
//            let quotationPattern = "^(.*?)\".*//.*\"";
//
//            do {
//
//                var newLine = line
//
//
//                let regularExpression = try NSRegularExpression(pattern: quotationPattern)
//                let result = regularExpression.matches(in: newLine,
//                    range: NSMakeRange(0, newLine.count))
//                if result.count > 0 {
//                    newLine = newLine.nsString.replacingCharacters(in: result[0].range, with: "")
//                    print(result[0].range, "newLine = \(newLine)")
//                    replaceFlag = true
//                }
//
//                let trimmedString = newLine.trimmingCharacters(in: .whitespacesAndNewlines)
//
//                if (trimmedString.hasPrefix("//")) {
//                    continue
//                }
//                if (trimmedString.hasPrefix("/*") && line.hasSuffix("*/")) {
//                    continue
//                }
//
//                if try NSRegularExpression(pattern: "^/\\*").numberOfMatches(in: trimmedString, range: NSMakeRange(0, trimmedString.count)) > 0 {
//                    inBlock = true
//                }
//                if try NSRegularExpression(pattern: "\\*/$").numberOfMatches(in: trimmedString, range: NSMakeRange(0, trimmedString.count)) > 0 {
//                    inBlock = false
//                    continue
//                }
//
//                let pattern = "[^(.*?)//(.*)]|[^(.*?)/\\*(.*)\\*/]"
//                // var pattern = @"[^(.*?)//(.*)]|[^(.*?)/\*(.*)\*/]";
//
//                let patternResult = try NSRegularExpression(pattern: pattern).matches(in: trimmedString, range: NSMakeRange(0, trimmedString.count))
//                if patternResult.count > 0 && patternResult[0].numberOfRanges >= 1 {
//                    newLine = trimmedString.nsString.substring(with: patternResult[0].range(at: 1))
//                }
//
//                // 还原被替换的代码
//                if replaceFlag {
//                    print("还原特殊代码")
//                   //  newLine = line.replacingCharacters(in: <#T##RangeExpression#>, with: tempLine)
//                    replaceFlag = false;
//                }
//
//                if inBlock {
//                    continue
//                }
//                newSource += newLine as String + "\n";
//
//            } catch {
//
//                print("error")
//
//            }
//        }
//
//        return newSource
//
//    }
//
//}
//
