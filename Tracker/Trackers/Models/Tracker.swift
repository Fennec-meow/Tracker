//
//  Tracker.swift
//  Tracker
//
//  Created by Kira on 30.04.2025.
//

import UIKit

struct Tracker {
    let trackerID: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: [WeekDay]
    let type: TypeTrackers
}
