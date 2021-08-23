//
//  Attributed String Extensions.swift
//  Kanji Kitsune
//
//  Created by Nicholas Alba on 8/19/21.
//

import Foundation

func + (left: NSAttributedString, right: NSAttributedString) -> NSAttributedString {
    let result = NSMutableAttributedString()
    result.append(left)
    result.append(right)
    return result
}
