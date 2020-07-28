//
//  CDSearchViewControllerDelegate.swift
//  C+++
//
//  Created by 23786 on 2020/7/28.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

protocol CDSearchViewControllerDelegate {
    
    func searchViewController(_ vc: CDSearchViewController, shouldSearchForWordInTextView word: String)
    
    func searchViewController(_ vc: CDSearchViewController, shouldInsertCodeSnippetWithCode code: String)

}
