//
//  CDTextViewDelegate.swift
//  Code Editor
//
//  Created by apple on 2020/4/18.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

@objc
protocol CDTextViewDelegate {
    
    @objc
    optional func didChangeText(lines: Int, characters: Int)
    
    @objc
    optional func didChangeText()
    
    @objc
    optional func didChangeText(lines: Int, currentLine: Int)
    
}
