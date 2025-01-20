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

    func addWorkout(name: String, exercises: [Exercise]) {
        let newWorkout = Workout(name: name, exercises: exercises)
        workouts.append(newWorkout)
        PersistenceManager.saveWorkouts(workouts)
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
