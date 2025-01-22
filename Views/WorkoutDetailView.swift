import SwiftUI

struct WorkoutDetailView: View {
    @ObservedObject var viewModel: ModelsViewModel
    @Binding var workout: Workout

    @State private var selectedExercise: Exercise? = nil
    @State private var isAddingExercise: Bool = false

    var body: some View {
        NavigationView {
            List {
                // Display exercises from the workout
                ForEach(workout.exercises) { exercise in
                    Section(header: Text(exercise.name).font(.headline)) {
                        // Display entries for the exercise
                        if exercise.entries.isEmpty {
                            Text("No entries yet.")
                                .foregroundColor(.gray)
                                .font(.caption)
                        } else {
                            ForEach(exercise.entries.sorted(by: { $0.date > $1.date })) { entry in
                                HStack(alignment: .center, spacing: 16) {
                                    Text("Reps: \(entry.reps)")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text("Sets: \(entry.sets)")
                                        .frame(maxWidth: .infinity, alignment: .center)
                                    Text("\(String(format: "%.1f", entry.weight)) kg")
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                }
                                .padding(.vertical, 4)
                            }
                        }

                        // Add Entry Button
                        Button(action: { selectExercise(exercise) }) {
                            Text("Add")
                                .fontWeight(.regular)
                                .padding(.vertical, 4)
                                .frame(maxWidth: .infinity)
                        }
                        .foregroundColor(Color.blue)
                    }
                }
            }
            .navigationTitle(workout.name)
            .toolbar {
                // Clear All Entries Button in the Navigation Bar
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Clear All") {
                        clearAllEntries()
                    }
                    .foregroundColor(.red)
                }
            }
            .sheet(isPresented: $isAddingExercise) {
                addEntrySheet
            }
        }
    }

    // MARK: - Add Entry Sheet
    private var addEntrySheet: some View {
        AddEntryView(
            exercise: selectedExercise ?? Exercise(name: "Default Exercise", entries: []),
            onSave: { newEntry in
                saveEntry(newEntry)
            }
        )
    }

    // MARK: - Save Entry Logic
    private func saveEntry(_ newEntry: ExerciseEntry) {
        guard let selectedExercise = selectedExercise else { return }

        // Update the workout's exercise
        if let workoutExerciseIndex = workout.exercises.firstIndex(where: { $0.id == selectedExercise.id }) {
            workout.exercises[workoutExerciseIndex].entries.append(newEntry)
        }

        // Update the corresponding global exercise
        if let viewModelExerciseIndex = viewModel.exercises.firstIndex(where: { $0.id == selectedExercise.id }) {
            viewModel.exercises[viewModelExerciseIndex].entries.append(newEntry)
        }

        // Persist the changes
        PersistenceManager.saveWorkouts(viewModel.workouts)
        PersistenceManager.saveExercises(viewModel.exercises)

        // Close the sheet
        isAddingExercise = false
    }

    // MARK: - Clear All Entries
    private func clearAllEntries() {
        // Clear entries only in the workout's exercises
        for index in workout.exercises.indices {
            workout.exercises[index].entries.removeAll()
        }

        // Persist the changes
        PersistenceManager.saveWorkouts(viewModel.workouts)
    }

    // MARK: - Helper Methods
    private func selectExercise(_ exercise: Exercise) {
        selectedExercise = exercise
        isAddingExercise = true
    }
}
