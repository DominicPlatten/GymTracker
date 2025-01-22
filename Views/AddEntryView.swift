import SwiftUI

struct AddEntryView: View {
    let exercise: Exercise
    @State private var reps: Int = 0
    @State private var sets: Int = 0
    @State private var weight: Double = 0.0

    var onSave: (ExerciseEntry) -> Void
    
    // Access the dismiss action from the environment
    @Environment(\.dismiss) private var dismiss


    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Exercise: \(exercise.name)")) {
                    Stepper("Reps: \(reps)", value: $reps)
                    Stepper("Sets: \(sets)", value: $sets)
                    HStack {
                        Text("Weight: \(String(format: "%.1f", weight)) kg")
                        Spacer()
                        Slider(value: $weight, in: 0...200, step: 0.5)
                    }
                }.onAppear {
                    print("Loaded AddEntryView for exercise: \(exercise.name)")
                }
            }
            .navigationTitle("Add Entry")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let newEntry = ExerciseEntry(
                            name: exercise.name,
                            reps: reps,
                            sets: sets,
                            weight: weight
                        )
                        onSave(newEntry)
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss() // Dismiss the view when cancel is tapped
                    }
                }
            }
        }
    }
}
