//
//  AddHabitView.swift
//  HabitTracker
//
//  Created by Divpreet Singh on 12/3/24.
//

import SwiftUI
import EmojiPicker

struct AddHabitView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: HabitViewModel
    
    @State private var title = ""
    @State private var icon = "🌟"
    @State private var color = "Blue"
    @State private var displayEmojiPicker = false
    @State private var selectedEmoji: Emoji? = nil
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Habit Title", text: $title)
                
                HStack {
                    Text("Emoji: \(icon)")
                    Spacer()
                    Button(action: {
                        displayEmojiPicker = true
                    }) {
                        Text("Select Emoji!")
                    }
                }
                
                Picker("Color", selection: $color) {
                    ForEach(["Red", "Blue", "Green", "Yellow"], id: \.self) { color in
                        Text(color).tag(color)
                    }
                }
            }
            .navigationTitle("Add New Habit")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        viewModel.addHabit(title: title, icon: icon, color: color)
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $displayEmojiPicker) {
                EmojiPickerView(selectedEmoji: $selectedEmoji, searchEnabled: true, selectedColor: .orange)
                    .navigationTitle("Select Emoji")
                    .onDisappear {
                        // Update the icon string when the picker closes
                        if let emoji = selectedEmoji {
                            icon = emoji.value
                        }
                    }
            }
        }
    }
}
