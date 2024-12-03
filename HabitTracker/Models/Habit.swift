import Foundation

struct Habit: Identifiable, Codable {
    var id = UUID()
    var title: String
    var icon: String
    var color: String
    var streak: Int
    var completedToday: Bool = false
    var lastCompletedDate: Date? = nil
}
