//
//  ViewController Extensions.swift
//  Kanji Kitsune
//
//  Created by Nicholas Alba on 8/14/21.
//

import UIKit

extension UIViewController {

    var backgroundColor: UIColor {
        if traitCollection.userInterfaceStyle == .dark {
            return UIColor.black
        } else {
            return UIColor.white
        }
    }
    
    var borderColor: UIColor {
        if traitCollection.userInterfaceStyle == .dark {
            return UIColor(named: "LavenderGamma") ?? UIColor.white
        } else {
            return UIColor.black
        }
    }
    
    var contentBackgroundColor: UIColor {
        if traitCollection.userInterfaceStyle == .dark {
            return UIColor(named: "LavenderAlpha") ?? .black
        } else {
            return UIColor.white
        }
    }
    
    var textColor: UIColor {
        if traitCollection.userInterfaceStyle == .dark {
            return UIColor(named: "LavenderDelta") ?? UIColor.white
        } else {
            return UIColor.black
        }
    }
}
