//
//  CDCodeEditor Extension.swift
//  C+++
//
//  Created by 23786 on 2020/8/9.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

extension CDCodeEditor {
    
    @IBAction func biggerFont(_ sender: Any?) {
        
        let settings = CDSettings.shared
        settings?.fontSize += 1
        CDSettings.shared = settings
        
    }
    
    @IBAction func smallerFont(_ sender: Any?) {
        
        let settings = CDSettings.shared
        settings?.fontSize -= 1
        CDSettings.shared = settings
        
    }
    
    @IBAction func changeSelectionToComment(_ sender: Any?) {
        
        var range = self.selectedRange
        var lineRange = NSMakeRange(0, 0)
        for line in self.string.components(separatedBy: .newlines) {
            lineRange.length = line.count + 1
            let anotherRange = NSIntersectionRange(range, lineRange)
            if anotherRange.length != 0 {
                self.string = self.string.nsString.replacingCharacters(in: NSMakeRange(lineRange.location, lineRange.length - 1), with: "//" + line)
                lineRange.location += line.count + 3
                range.length += 2
                continue
            }
            lineRange.location += line.count + 1
        }
        self.setSelectedRange(range)
        self.didChangeText()
        
    }
    
    @IBAction func shiftRight(_ sender: Any?) {
        
        var range = self.selectedRange
        var lineRange = NSMakeRange(0, 0)
        for line in self.string.components(separatedBy: .newlines) {
            lineRange.length = line.count + 1
            let anotherRange = NSIntersectionRange(range, lineRange)
            if anotherRange.length != 0 {
                self.string = self.string.nsString.replacingCharacters(in: NSMakeRange(lineRange.location, lineRange.length - 1), with: "\t" + line)
                lineRange.location += line.count + 2
                range.length += 1
                continue
            }
            lineRange.location += line.count + 1
        }
        self.setSelectedRange(range)
        self.didChangeText()
        
    }
    
    @IBAction func shiftLeft(_ sender: Any?) {
        
        var range = self.selectedRange
        var lineRange = NSMakeRange(0, 0)
        for line in self.string.components(separatedBy: .newlines) {
            lineRange.length = line.count + 1
            let anotherRange = NSIntersectionRange(range, lineRange)
            if anotherRange.length != 0 {
                if line.hasPrefix("\t") {
                    self.string = self.string.nsString.replacingCharacters(in: NSMakeRange(lineRange.location, lineRange.length - 1), with: String(line.dropFirst()))
                    lineRange.location += line.count
                    range.length -= 1
                } else {
                    lineRange.location += line.count + 1
                }
                continue
            }
            lineRange.location += line.count + 1
        }
        self.setSelectedRange(range)
        self.didChangeText()
        
    }
    
}
