//
//  Transformers.swift
//  Kanji Kitsune
//
//  Created by Nicholas Alba on 7/22/21.
//

import Foundation

@objc class HintValueTransformer: NSSecureUnarchiveFromDataTransformer {
    
    public static func register() {
        let transformer = HintValueTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
    
    override static var allowedTopLevelClasses: [AnyClass] {
        return [Hint.self, NSArray.self]
    }
    
    static let name = NSValueTransformerName(rawValue: String(describing: HintValueTransformer.self))
}
