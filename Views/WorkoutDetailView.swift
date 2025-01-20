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
        .navigationTitle(workout.name)
    }

    private func initializeData() {
        if !isInitialized {
            for exercise in workout.exercises {
                trackingData[exercise.id] = trackingData[exercise.id] ?? ExerciseTracking(reps: 0, sets: 0, weight: 0.0)
                addedEntries[exercise.id] = addedEntries[exercise.id] ?? []
            }
            isInitialized = true
        }
    }
}
