//
//  PersistenceManager.swift
//  TestApp
//
//  Created by Dominic Platten on 18.01.2025.
//

import Foundation

class PersistenceManager {
    static private func getExercisesFileURL() -> URL? {
        let fileManager = FileManager.default
        if let documentsDir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            return documentsDir.appendingPathComponent("exercises.json")
        }
        return nil
    }
    
    static private func getWorkoutsFileURL() -> URL? {
        let fileManager = FileManager.default
        if let documentsDir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            return documentsDir.appendingPathComponent("workouts.json")
        }
        return nil
    }

    static func saveExercises(_ exercises: [Exercise]) {
        guard let fileURL = getExercisesFileURL() else { return }
        do {
            let data = try JSONEncoder().encode(exercises)
            try data.write(to: fileURL)
        } catch {
            print("Failed to save exercises: \(error)")
        }
    }

    static func loadExercises() -> [Exercise] {
        guard let fileURL = getExercisesFileURL() else { return [] }
        do {
            let data = try Data(contentsOf: fileURL)
            let exercises = try JSONDecoder().decode([Exercise].self, from: data)
            return exercises
        } catch {
            print("Failed to load exercises: \(error)")
            return []
        }
    }

    static func saveWorkouts(_ workouts: [Workout]) {
        guard let fileURL = getWorkoutsFileURL() else { return }
        do {
            let data = try JSONEncoder().encode(workouts)
            try data.write(to: fileURL)
        } catch {
            print("Failed to save workouts: \(error)")
        }
    }

    static func loadWorkouts() -> [Workout] {
        guard let fileURL = getWorkoutsFileURL() else { return [] }
        do {
            let data = try Data(contentsOf: fileURL)
            let workouts = try JSONDecoder().decode([Workout].self, from: data)
            return workouts
        } catch {
            print("Failed to load workouts: \(error)")
            return []
        }
    }
}
