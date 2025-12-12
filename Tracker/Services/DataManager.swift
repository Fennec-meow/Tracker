import Foundation

final class DataManager {
    
    static let shared = DataManager()
    private init() {}
    
    var categories: [TrackerCategory] = [
        TrackerCategory(
            headingCategory: "Домашний уют",
            trackers: [
                Tracker(
                    trackerID: UUID(),
                    name: "Поливать растения",
                    color: .colorSelection5,
                    emoji: "❤️",
                    schedule: [WeekDay.monday, WeekDay.saturday],
                    type: .habit,
                    isPinned: false
                ),
            ]
        ),
        TrackerCategory(
            headingCategory: "Радостные мелочи",
            trackers: [
                Tracker(
                    trackerID: UUID(),
                    name: "Кошка заслонила камеру на созвоне",
                    color: .colorSelection2,
                    emoji: "😻",
                    schedule: [WeekDay.friday, WeekDay.tuesday],
                    type: .habit,
                    isPinned: false
                ),
                Tracker(
                    trackerID: UUID(),
                    name: "Бабушка прислала открытку в вотсапе",
                    color: .colorSelection1,
                    emoji: "🌺",
                    schedule: [WeekDay.wednesday, WeekDay.monday, WeekDay.thursday],
                    type: .habit,
                    isPinned: false
                ),
                Tracker(
                    trackerID: UUID(),
                    name: "Свидания в апреле",
                    color: .colorSelection14,
                    emoji: "❤️",
                    schedule: [WeekDay.thursday],
                    type: .irregularEvent,
                    isPinned: false
                )
            ]
        ),
        TrackerCategory(
            headingCategory: "Самочувствие",
            trackers: [
                Tracker(
                    trackerID: UUID(),
                    name: "Хорошее настроение",
                    color: .colorSelection16,
                    emoji: "🙂",
                    schedule: [WeekDay.sunday, WeekDay.tuesday],
                    type: .habit,
                    isPinned: false
                ),
                Tracker(
                    trackerID: UUID(),
                    name: "Легкая тревожность",
                    color: .colorSelection8,
                    emoji: "😪",
                    schedule: [WeekDay.saturday],
                    type: .irregularEvent,
                    isPinned: false
                )
            ]
        )
    ]
}
