import Foundation

struct Workout: Codable, Identifiable {
    let id: UUID
    let date: Date
    var name: String
    var exercises: [Exercise]
    var trackingData: [UUID: ExerciseTracking] // Tracks progress per exercise
    var addedEntries: [UUID: [ExerciseTracking]] // Stores additional tracking data
    var lastTracked: [UUID: ExerciseTracking]? // Optional: Tracks the most recent progress per exercise

    init(id: UUID = UUID(), name: String, exercises: [Exercise] = []) {
        self.id = id
        self.date = Date()
        self.name = name
        self.exercises = exercises
        self.trackingData = [:]
        self.addedEntries = [:]
        self.lastTracked = nil
    }

    // MARK: - Clear All Entries
    mutating func clearAllEntries() {
        // Clear all entries in each exercise
        for index in exercises.indices {
            exercises[index].entries.removeAll()
        }

        // Optionally clear trackingData and addedEntries if needed
        trackingData.removeAll()
        addedEntries.removeAll()
        lastTracked = nil
    }
}
