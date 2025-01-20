import SwiftUI

struct AddExerciseView: View {
    @ObservedObject var viewModel: ModelsViewModel
    @Environment(\.dismiss) var dismiss

    @State private var exerciseName: String = "" // State to capture the exercise name
    @State private var reps: Int = 0
    @State private var sets: Int = 0
    @State private var weight: Double = 0.0

    var body: some View {
        NavigationView {
            Form {
                // Input for the Exercise Name
                TextField("Exercise Name", text: $exerciseName)

                // Inputs for Reps, Sets, and Weight
                Stepper("Reps: \(reps)", value: $reps, in: 0...100)
                Stepper("Sets: \(sets)", value: $sets, in: 0...20)
                VStack {
                    Text("Weight: \(String(format: "%.1f", weight)) kg")
                    Slider(value: $weight, in: 0...200, step: 0.5)
                }
            }
            .navigationTitle("Add Exercise")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button("Save") {
                        // Ensure an exercise name is provided
                        if !exerciseName.isEmpty {
                            viewModel.addExercise(name: exerciseName, reps: reps, sets: sets, weight: weight)
                            dismiss() // Close the sheet
                        }
                    }
                    .disabled(exerciseName.isEmpty) // Disable Save if name is empty
                }
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss() // Close the sheet
                    }
                }
            }
        }
    }
}

#Preview {
    AddExerciseView(viewModel: ModelsViewModel())
}
