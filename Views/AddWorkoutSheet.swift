import SwiftUI

struct AddWorkoutSheet: View {
    @ObservedObject var viewModel: ModelsViewModel
    @Binding var isAddingWorkout: Bool
    @State private var workoutName: String = ""
    @State private var selectedExercises: Set<UUID> = []

    var body: some View {
        NavigationView {
            VStack {
                TextField("Workout Name", text: $workoutName)
                    .padding()
                    .background(Color(.systemGray5))
                    .cornerRadius(10)

                List(viewModel.exercises) { exercise in
                    Button(action: {
                        if selectedExercises.contains(exercise.id) {
                            selectedExercises.remove(exercise.id)
                        } else {
                            selectedExercises.insert(exercise.id)
                        }
                    }) {
                        HStack {
                            Text(exercise.name)
                            Spacer()
                            if selectedExercises.contains(exercise.id) {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }

                Button("Save Workout") {
                    let exercises = viewModel.exercises.filter { selectedExercises.contains($0.id) }
                    viewModel.addWorkout(name: workoutName, exercises: exercises)
                    isAddingWorkout = false
                }
                .disabled(workoutName.isEmpty || selectedExercises.isEmpty)
                .padding()
                .buttonStyle(CustomButtonStyle())
            }
            .navigationTitle("Add Workout")
        }
    }
}
