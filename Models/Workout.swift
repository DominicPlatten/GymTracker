import Foundation

struct Workout: Codable, Identifiable {
    let id: UUID
    var name: String
    var exercises: [Exercise]
    var trackingData: [UUID: ExerciseTracking] // Tracks progress per exercise
    var addedEntries: [UUID: [ExerciseTracking]] // Stores additional tracking data
    var lastTracked: [UUID: ExerciseTracking]? // Optional: Tracks the most recent progress per exercise

    init(id: UUID = UUID(), name: String, exercises: [Exercise] = []) {
        self.id = id
        self.name = name
        self.exercises = exercises
        self.trackingData = [:]
        self.addedEntries = [:]
        self.lastTracked = nil
    }
}

