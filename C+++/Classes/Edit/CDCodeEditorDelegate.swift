//
//  CDTextViewDelegate.swift
//  C+++
//
//  Created by apple on 2020/4/18.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

@objc
protocol CDCodeEditorDelegate {
    
    @objc
    optional func codeEditorDidChangeText(lines: Int, characters: Int)
    
    @objc
    optional func codeEditorDidChangeText()
    
    @objc
    optional func codeEditorDidChangeText(lines: Int, currentLine: Int)
    
    @objc
    optional func codeEditorDidChangeText(lineRects: [NSRect])
    
}
