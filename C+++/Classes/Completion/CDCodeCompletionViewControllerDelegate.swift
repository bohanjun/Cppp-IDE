//
//  CDCodeCompletionViewControllerDelegate.swift
//  C+++
//
//  Created by 23786 on 2020/6/28.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

protocol CDCodeCompletionViewControllerDelegate {
    
    func codeCompletionViewController(_ viewController: CDCodeCompletionViewController, didSelectItemWithTitle title: String, range: NSRange)
    
}
