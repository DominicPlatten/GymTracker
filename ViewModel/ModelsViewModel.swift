import Foundation

class ModelsViewModel: ObservableObject {
    @Published var exercises: [Exercise] = []
    @Published var workouts: [Workout] = []

    init() {
        self.exercises = PersistenceManager.loadExercises()
        self.workouts = PersistenceManager.loadWorkouts()
    }

    func addExercise(name: String, reps: Int, sets: Int, weight: Double) {
        let newExercise = Exercise(name: name, reps: reps, sets: sets, weight: weight)
        exercises.append(newExercise)
        PersistenceManager.saveExercises(exercises)
    }

    func deleteExercise(at offsets: IndexSet) {
        exercises.remove(atOffsets: offsets)
        PersistenceManager.saveExercises(exercises)
    }

    func addWorkout(name: String, selectedExercises: [Exercise]) {
        let workoutExercises = selectedExercises.compactMap { selectedExercise in
            exercises.first(where: { $0.id == selectedExercise.id })
        }
        let newWorkout = Workout(name: name, exercises: workoutExercises)

        // Add the new workout
        workouts.append(newWorkout)

        // Clear all entries in the newly created workout
        if let workoutIndex = workouts.firstIndex(where: { $0.id == newWorkout.id }) {
            for index in workouts[workoutIndex].exercises.indices {
                workouts[workoutIndex].exercises[index].entries.removeAll()
            }
        }

        // Persist the changes
        PersistenceManager.saveWorkouts(workouts)
    }
    
    func deleteWorkout(_ workout: Workout) {
        if let index = workouts.firstIndex(where: { $0.id == workout.id }) {
            workouts.remove(at: index)
            PersistenceManager.saveWorkouts(workouts)
        }
    }

    func trackWorkout(workout: Workout, trackingData: [UUID: ExerciseTracking]) {
        if let index = workouts.firstIndex(where: { $0.id == workout.id }) {
            workouts[index].lastTracked = trackingData
            PersistenceManager.saveWorkouts(workouts)
        }
    }
    
    func addEntry(toExerciseId exerciseId: UUID, name: String, reps: Int, sets: Int, weight: Double) {
        guard let index = exercises.firstIndex(where: { $0.id == exerciseId }) else {
            print("Error: Exercise not found")
            return
        }

        let newEntry = ExerciseEntry(name: name, reps: reps, sets: sets, weight: weight)
        exercises[index].entries.append(newEntry)
        PersistenceManager.saveExercises(exercises)
    }
}
