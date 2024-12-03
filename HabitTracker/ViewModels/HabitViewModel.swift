import Foundation

class HabitViewModel: ObservableObject {
    @Published var habits: [Habit] = []

    init() {
        loadHabits()
        resetHabitsIfNewDay() // Reset habits at initialization
    }

    func addHabit(title: String, icon: String, color: String) {
        let newHabit = Habit(title: title, icon: icon, color: color, streak: 0)
        habits.append(newHabit)
        saveHabits()
    }

    func toggleHabitCompletion(for habit: Habit) {
        if let index = habits.firstIndex(where: { $0.id == habit.id }) {
            var updatedHabit = habits[index]

            if !updatedHabit.completedToday {
                updatedHabit.completedToday = true
                updatedHabit.streak += 1
                updatedHabit.lastCompletedDate = Date() // Update the last completed date
            } else {
                updatedHabit.completedToday = false
                updatedHabit.streak = max(updatedHabit.streak - 1, 0)
            }

            habits[index] = updatedHabit
            saveHabits()
        }
    }

    func resetHabitsIfNewDay() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        for i in 0..<habits.count {
            if let lastDate = habits[i].lastCompletedDate {
                let lastCompletedDay = calendar.startOfDay(for: lastDate)
                if today > lastCompletedDay { // It's a new day
                    habits[i].completedToday = false
                }
            }
        }
        saveHabits()
    }

    func deleteHabit(at offsets: IndexSet) {
        habits.remove(atOffsets: offsets)
        saveHabits()
    }

    private func saveHabits() {
        if let encoded = try? JSONEncoder().encode(habits) {
            UserDefaults.standard.set(encoded, forKey: "Habits")
        }
    }

    private func loadHabits() {
        if let savedData = UserDefaults.standard.data(forKey: "Habits"),
           let decoded = try? JSONDecoder().decode([Habit].self, from: savedData) {
            habits = decoded
        }
    }
}
