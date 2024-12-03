import SwiftUI
import ConfettiSwiftUI

struct ContentView: View {
    @StateObject var viewModel = HabitViewModel()
    @State private var showingAddHabit = false
    @State private var showConfetti = false
    @State private var counter: Int = 0

    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.habits.isEmpty {
                    Text("No habits yet, create one!")
                        .font(.title2)
                        .foregroundColor(.gray)
                } else {
                    List {
                        ForEach(viewModel.habits) { habit in
                            HStack {
                                Text(habit.icon)
                                    .font(.largeTitle)
                                VStack(alignment: .leading) {
                                    Text(habit.title)
                                        .font(.headline)
                                    Text("Streak: \(habit.streak) days")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                Button(action: {
                                    if !habit.completedToday {
                                        counter += 1 // Increment the counter to trigger the confetti
                                    }
                                    viewModel.toggleHabitCompletion(for: habit)
                                }) {
                                    Image(systemName: habit.completedToday ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(habit.completedToday ? .green : .gray)
                                        .scaleEffect(habit.completedToday ? 1.2 : 1.0)
                                        .animation(.spring(), value: habit.completedToday)
                                }
                            }
                            .padding(.vertical, 8)
                        }
                        .onDelete(perform: viewModel.deleteHabit) // Pass the method directly
                    }
                }

                // Confetti Cannon overlay
                ConfettiCannon(counter: $counter, repetitions: 5, repetitionInterval: 0.1)
            }
            .navigationTitle("Habits")
            .onAppear {
                viewModel.resetHabitsIfNewDay()
            }
            .toolbar {
                Button(action: {
                    showingAddHabit.toggle()
                }) {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddHabit) {
                AddHabitView(viewModel: viewModel)
            }
        }
    }
}
