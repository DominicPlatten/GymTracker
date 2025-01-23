import SwiftUI

struct WorkoutDetailView: View {
    @ObservedObject var viewModel: ModelsViewModel
    @Binding var workout: Workout

    @State private var selectedIndex: Int = 0
    @State private var selectedExercise: Exercise? = nil
    @State private var isAddingExercise: Bool = false
    @State private var isDeleteMode: Bool = false

    private var matchingWorkouts: [Workout] {
        viewModel.workouts.filter { $0.name == workout.name }
                          .sorted(by: { $0.date < $1.date })
    }

    private var numberOfSessions: Int {
        matchingWorkouts.count
    }

    private var currentWorkout: Workout {
        matchingWorkouts[selectedIndex]
    }

    private var formattedCurrentDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: currentWorkout.date)
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(currentWorkout.exercises) { exercise in
                    Section(header: Text(exercise.name).font(.headline)) {
                        if exercise.entries.isEmpty {
                            Text("No entries yet.")
                                .foregroundColor(.gray)
                                .font(.caption)
                        } else {
                            ForEach(exercise.entries.sorted(by: { $0.date > $1.date })) { entry in
                                HStack(alignment: .center, spacing: 16) {
                                    Text("Reps: \(entry.reps)")
                                    Text("Sets: \(entry.sets)")
                                    Text("\(String(format: "%.1f", entry.weight)) kg")
                                    
                                    if isDeleteMode {
                                        Spacer()
                                        Button(action: { clearSingleEntry(entry, for: exercise) }) {
                                            Image(systemName: "trash")
                                                .foregroundColor(.red)
                                        }
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                        }

                        Button(action: { selectExercise(exercise) }) {
                            Text("Add")
                        }
                        .foregroundColor(Color.blue)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        if selectedIndex > 0 {
                            selectedIndex -= 1
                        }
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                    .disabled(selectedIndex == 0)
                }

                ToolbarItem(placement: .principal) {
                    Text(formattedCurrentDate)
                        .font(.headline)
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if selectedIndex < numberOfSessions - 1 {
                            selectedIndex += 1
                        }
                    } label: {
                        Image(systemName: "chevron.right")
                    }
                    .disabled(selectedIndex == numberOfSessions - 1)
                }
            }
            .sheet(isPresented: $isAddingExercise) {
                addEntrySheet
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(isDeleteMode ? "Done" : "Edit") {
                    isDeleteMode.toggle()
                }
            }
        }
    }

    private var addEntrySheet: some View {
        AddEntryView(
            exercise: selectedExercise ?? Exercise(name: "Default Exercise", entries: []),
            onSave: saveEntry
        )
    }

    private func saveEntry(_ newEntry: ExerciseEntry) {
        guard let selectedExercise = selectedExercise else { return }
        
        // Find the global workout index
        if let workoutIndex = viewModel.workouts.firstIndex(where: { $0.id == currentWorkout.id }) {
            // Find the exercise index in the workout
            if let exerciseIndex = viewModel.workouts[workoutIndex].exercises.firstIndex(where: { $0.id == selectedExercise.id }) {
                // Append the new entry
                viewModel.workouts[workoutIndex].exercises[exerciseIndex].entries.append(newEntry)
            }
        }

        // Update the corresponding global exercise
        if let viewModelExerciseIndex = viewModel.exercises.firstIndex(where: { $0.id == selectedExercise.id }) {
            viewModel.exercises[viewModelExerciseIndex].entries.append(newEntry)
        }

        // Persist the changes
        PersistenceManager.saveWorkouts(viewModel.workouts)
        PersistenceManager.saveExercises(viewModel.exercises)

        isAddingExercise = false
    }

    private func clearAllEntries() {
        if let workoutIndex = viewModel.workouts.firstIndex(where: { $0.id == currentWorkout.id }) {
            for exerciseIndex in viewModel.workouts[workoutIndex].exercises.indices {
                viewModel.workouts[workoutIndex].exercises[exerciseIndex].entries.removeAll()
            }
        }

        // Persist changes
        PersistenceManager.saveWorkouts(viewModel.workouts)
    }
    
    private func clearSingleEntry(_ entry: ExerciseEntry, for exercise: Exercise) {
        // Find the global workout index
        if let workoutIndex = viewModel.workouts.firstIndex(where: { $0.id == currentWorkout.id }) {
            // Find the exercise index in the workout
            if let exerciseIndex = viewModel.workouts[workoutIndex].exercises.firstIndex(where: { $0.id == exercise.id }) {
                // Remove the specific entry
                viewModel.workouts[workoutIndex].exercises[exerciseIndex].entries.removeAll(where: { $0.id == entry.id })
            }
        }
        
        // Persist the changes
        PersistenceManager.saveWorkouts(viewModel.workouts)
    }
    

    private func selectExercise(_ exercise: Exercise) {
        selectedExercise = exercise
        isAddingExercise = true
    }
}
    /*// MARK: - Save Entry Logic
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
    }*/
