import SwiftUI

struct AddExerciseSheet: View {
    @ObservedObject var viewModel: ModelsViewModel
    @Binding var isAddingExercise: Bool

    @State private var exerciseName: String = ""
    @State private var reps: Int = 0
    @State private var sets: Int = 0
    @State private var weight: Double = 0.0

    var body: some View {
        NavigationView {
            Form {
                // Input for the exercise name
                Section {
                    TextField("Exercise Name", text: $exerciseName)
                }

                // Inputs for reps, sets, and weight
                Section(header: Text("Workout Details")) {
                    Stepper("Reps: \(reps)", value: $reps, in: 0...100)
                    Stepper("Sets: \(sets)", value: $sets, in: 0...20)

                    VStack {
                        Text("Weight: \(String(format: "%.1f", weight)) kg")
                        Slider(value: $weight, in: 0...200, step: 0.5)
                    }
                }
            }
            .navigationTitle("Add Exercise")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if !exerciseName.isEmpty {
                            viewModel.addExercise(name: exerciseName, reps: reps, sets: sets, weight: weight)
                            isAddingExercise = false // Dismiss the sheet
                        }
                    }
                    .disabled(exerciseName.isEmpty) // Disable Save if name is empty
                }
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isAddingExercise = false // Dismiss the sheet
                    }
                }
            }
        }
    }
}

#Preview {
    AddExerciseSheet(viewModel: ModelsViewModel(), isAddingExercise: .constant(true))
}
