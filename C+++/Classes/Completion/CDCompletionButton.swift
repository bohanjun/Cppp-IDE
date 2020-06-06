//
//  CDCompletionButton.swift
//  C+++
//
//  Created by 23786 on 2020/6/6.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

class CDCompletionButton: NSButton {

    var partialWordRange: NSRange!
    
}

/*

 func complete(Any?)
// Invokes completion in a text view.
 func completions(forPartialWordRange: NSRange, indexOfSelectedItem: UnsafeMutablePointer<Int>) -> [String]?
// Returns an array of potential completions, in the order to be presented, representing possible word completions available from a partial word.
 func insertCompletion(String, forPartialWordRange: NSRange, movement: Int, isFinal: Bool)
// Inserts the selected completion into the text at the appropriate location.
 var rangeForUserCompletion: NSRange
// The partial range from the most recent beginning of a word up to the insertion point.

 */
