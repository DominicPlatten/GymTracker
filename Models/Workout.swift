import Foundation

struct Workout: Identifiable, Codable {
    let id: UUID
    var name: String
    var exercises: [Exercise]
    var lastTracked: [UUID: ExerciseTracking]

    init(name: String, exercises: [Exercise] = [], lastTracked: [UUID: ExerciseTracking] = [:]) {
        self.id = UUID()
        self.name = name
        self.exercises = exercises
        self.lastTracked = lastTracked
    }
}

