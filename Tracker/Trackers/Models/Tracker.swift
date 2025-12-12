import UIKit

struct Tracker {
    let trackerID: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: [WeekDay]
    let type: TypeTrackers
    let isPinned: Bool
}
