//
//  TrackerCategory.swift
//  Tracker
//
//  Created by Kira on 30.04.2025.
//

import Foundation

struct TrackerCategory {
    var headingCategory: String
    var trackers: [Tracker]
}

// MARK: - Equatable

extension TrackerCategory: Equatable {
    static func == (lhs: TrackerCategory, rhs: TrackerCategory) -> Bool {
        lhs.headingCategory == rhs.headingCategory
    }
}
