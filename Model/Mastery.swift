//
//  Mastery.swift
//  Kanji Kitsune
//
//  Created by Nicholas Alba on 8/17/21.
//

import Foundation

func masteryString(for mastery: Int) -> String {
    switch mastery {
    case 0, 1:
        return "Mastered (\(mastery))"
    case 2, 3:
        return "Familiar (\(mastery))"
    case 4, 5, 6, 7, 8, 9, 10:
        return "Unfamiliar (\(mastery))"
    default:
        return ""
    }
}
