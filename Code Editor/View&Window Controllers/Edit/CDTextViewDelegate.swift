//
//  CDTextViewDelegate.swift
//  Code Editor
//
//  Created by apple on 2020/4/18.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

protocol CDTextViewDelegate {
    
    func didChangeText(lines: Int, characters: Int)
    
}
