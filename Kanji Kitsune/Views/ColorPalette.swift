//
//  ColorPalette.swift
//  Kanji Kitsune
//
//  Created by Nicholas Alba on 8/6/21.
//

import Foundation
import UIKit

struct ColorPalette {
    
    static func backgroundColor(forUserInterfaceStyle userInterfaceStyle: UIUserInterfaceStyle) -> UIColor {
        if userInterfaceStyle == .dark {
            return UIColor.black
        } else {
            return UIColor.white
        }
    }

    static func borderColor(forUserInterfaceStyle userInterfaceStyle: UIUserInterfaceStyle) -> UIColor {
        if userInterfaceStyle == .dark {
            return UIColor(named: "LavenderGamma") ?? UIColor.white
        } else {
            return UIColor.black
        }
    }
    
    static func contentBackgroundColor(forUserInterfaceStyle userInterfaceStyle: UIUserInterfaceStyle) -> UIColor {
        if userInterfaceStyle == .dark {
            return UIColor(named: "LavenderAlpha") ?? .black
        } else {
            return UIColor.white
        }
    }
    
    static func textColor(forUserInterfaceStyle userInterfaceStyle: UIUserInterfaceStyle) -> UIColor {
        if userInterfaceStyle == .dark {
            return UIColor(named: "LavenderDelta") ?? UIColor.white
        } else {
            return UIColor.black
        }
    }
    
}
