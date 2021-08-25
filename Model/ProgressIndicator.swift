//
//  ProgressIndicator.swift
//  Kanji Kitsune
//
//  Created by Nicholas Alba on 8/15/21.
//

import Foundation

struct ProgressIndicator {
    
    var completionPercentage: Int {
        return Int(Double(tasksCompleted) / Double(totalTasks) * 100)
    }
    
    var tasksCompleted: Int
    var totalTasks: Int
}
