//
//  ViewController Extensions.swift
//  Kanji Kitsune
//
//  Created by Nicholas Alba on 8/14/21.
//

import UIKit

extension UIViewController {

    var backgroundColor: UIColor {
        return UIColor.black
    }
    
    var borderColor: UIColor {
        return UIColor(named: "LavenderGamma") ?? UIColor.white
    }
    
    var contentBackgroundColor: UIColor {
        return UIColor(named: "LavenderAlpha") ?? .black
    }
    
    var textColor: UIColor {
        return UIColor(named: "LavenderDelta") ?? UIColor.white
    }
}
