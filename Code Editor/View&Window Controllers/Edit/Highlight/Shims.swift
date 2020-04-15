//
//  Shims.swift
//  Code Editor
//
//  Created by apple on 2020/3/26.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

#if swift(>=4.2)
    public typealias AttributedStringKey = NSAttributedString.Key
#else
    public typealias AttributedStringKey = NSAttributedStringKey
#endif

#if swift(>=4.2) && os(iOS)
    public typealias TextStorageEditActions = NSTextStorage.EditActions
#else
    public typealias TextStorageEditActions = NSTextStorageEditActions
#endif
