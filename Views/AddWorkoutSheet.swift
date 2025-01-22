import SwiftUI

struct AddWorkoutSheet: View {
    @ObservedObject var viewModel: ModelsViewModel
    @Binding var isAddingWorkout: Bool
    @State private var workoutName: String = ""
    @State private var selectedExercises: Set<UUID> = []

    var body: some View {
        NavigationView {
            Form {
                // Workout Name Section
                Section() {
                    TextField("Workout Name", text: $workoutName)
                }
                
                // Exercise Selection Section
                Section(header: Text("Select Exercises")) {
                    ForEach(viewModel.exercises) { exercise in
                        Button(action: {
                            if selectedExercises.contains(exercise.id) {
                                selectedExercises.remove(exercise.id)
                            } else {
                                selectedExercises.insert(exercise.id)
                            }
                        }) {
                            HStack {
                                Text(exercise.name)
                                    .font(.body)
                                Spacer()
                                if selectedExercises.contains(exercise.id) {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.accentColor)
                                }
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
            .navigationTitle("Add Workout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Cancel Button
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isAddingWorkout = false
                    }
                }
                
                // Save Button
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let selectedExerciseObjects = viewModel.exercises.filter { selectedExercises.contains($0.id) }
                        viewModel.addWorkout(name: workoutName, selectedExercises: selectedExerciseObjects)
                        isAddingWorkout = false
                    }
                    .disabled(workoutName.isEmpty || selectedExercises.isEmpty)
                }
            }
        }
    }
}

// MARK: - Preview
struct AddWorkoutSheet_Previews: PreviewProvider {
    static var previews: some View {
        AddWorkoutSheet(
            viewModel: ModelsViewModel(),
            isAddingWorkout: .constant(true)
        )
    }
}
