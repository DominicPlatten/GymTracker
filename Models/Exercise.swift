import Foundation

struct Exercise: Identifiable, Codable {
    let id: UUID
    var name: String
    var reps: Int
    var sets: Int
    var weight: Double
    var entries: [ExerciseEntry] // Add this property

    init(name: String, reps: Int = 0, sets: Int = 0, weight: Double = 0.0, entries: [ExerciseEntry] = []) {
        self.id = UUID()
        self.name = name
        self.reps = reps
        self.sets = sets
        self.weight = weight
        self.entries = entries
    }
}

struct ExerciseEntry: Identifiable, Codable {
    let id: UUID
    var name: String // Property for naming
    var date: Date
    var reps: Int
    var sets: Int
    var weight: Double

    init(name: String, reps: Int, sets: Int, weight: Double, date: Date = Date()) {
        self.id = UUID()
        self.name = name
        self.reps = reps
        self.sets = sets
        self.weight = weight
        self.date = date
    }
}

struct ExerciseTracking: Identifiable, Codable {
    let id: UUID
    var reps: Int
    var sets: Int
    var weight: Double

    init(reps: Int = 0, sets: Int = 0, weight: Double = 0.0) {
        self.id = UUID()
        self.reps = reps
        self.sets = sets
        self.weight = weight
    }
}
