import SwiftUI

struct WorkoutDetailView: View {
    @ObservedObject var viewModel: ModelsViewModel
    var workout: Workout
    @State private var trackingData: [UUID: ExerciseTracking] = [:]
    @State private var addedEntries: [UUID: [ExerciseTracking]] = [:]
    @State private var isInitialized = false

    var body: some View {
        VStack {
            if workout.exercises.isEmpty {
                Text("No exercises in this workout. Add some exercises!")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List(workout.exercises, id: \.id) { exercise in
                    ExerciseRowView(
                        exercise: exercise,
                        trackingData: $trackingData,
                        addedEntries: $addedEntries
                    )
                }
            }
        }
        .onAppear {
            initializeData()
        }
        .onDisappear {
            saveTrackingData()
        }
        .navigationTitle(workout.name)
    }

    private func initializeData() {
        // Load saved workouts and find this workout's tracking data
        let workouts = PersistenceManager.loadWorkouts()
        if let savedWorkout = workouts.first(where: { $0.id == workout.id }) {
            trackingData = savedWorkout.trackingData
            addedEntries = savedWorkout.addedEntries
        }
        isInitialized = true
    }

    private func saveTrackingData() {
        // Load all workouts, update this workout, and save back
        var workouts = PersistenceManager.loadWorkouts()
        if let index = workouts.firstIndex(where: { $0.id == workout.id }) {
            workouts[index].trackingData = trackingData
            workouts[index].addedEntries = addedEntries
        }
        PersistenceManager.saveWorkouts(workouts)
    }
}
