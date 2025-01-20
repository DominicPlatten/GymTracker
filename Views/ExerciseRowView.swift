import SwiftUI

struct ExerciseRowView: View {
    let exercise: Exercise
    @Binding var trackingData: [UUID: ExerciseTracking]
    @Binding var addedEntries: [UUID: [ExerciseTracking]]

    var body: some View {
        Section(header: Text(exercise.name)) {
            // Input fields for reps, sets, and weight
            VStack {
                Stepper("Reps: \(trackingData[exercise.id]?.reps ?? 0)", value: Binding(
                    get: { trackingData[exercise.id]?.reps ?? 0 },
                    set: { newValue in
                        updateTrackingData(for: exercise.id) { $0.reps = newValue }
                    }
                ))

                Stepper("Sets: \(trackingData[exercise.id]?.sets ?? 0)", value: Binding(
                    get: { trackingData[exercise.id]?.sets ?? 0 },
                    set: { newValue in
                        updateTrackingData(for: exercise.id) { $0.sets = newValue }
                    }
                ))

                VStack {
                    Text("Weight: \(String(format: "%.1f", trackingData[exercise.id]?.weight ?? 0)) kg")
                    Slider(value: Binding(
                        get: { trackingData[exercise.id]?.weight ?? 0 },
                        set: { newValue in
                            updateTrackingData(for: exercise.id) { $0.weight = newValue }
                        }
                    ), in: 0...200, step: 0.5)
                }
                .padding(.vertical, 8)
            }

            // Add button to save data for this exercise
            Button("Add") {
                addTrackingData(for: exercise.id)
            }
            .padding(.vertical, 4)
            .buttonStyle(CustomButtonStyle())

            // Display added entries
            if let entries = addedEntries[exercise.id], !entries.isEmpty {
                ForEach(entries, id: \.id) { entry in
                    VStack(alignment: .leading) {
                        Text("Reps: \(entry.reps), Sets: \(entry.sets), Weight: \(String(format: "%.1f", entry.weight)) kg")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            } else {
                Text("No entries yet.")
                    .foregroundColor(.gray)
                    .font(.caption)
            }
        }
    }

    // MARK: - Helper Methods

    private func updateTrackingData(for id: UUID, update: (inout ExerciseTracking) -> Void) {
        var tracking = trackingData[id] ?? ExerciseTracking()
        update(&tracking)
        trackingData[id] = tracking
    }

    private func addTrackingData(for id: UUID) {
        let tracking = trackingData[id] ?? ExerciseTracking()
        addedEntries[id, default: []].append(tracking)
        trackingData[id] = ExerciseTracking() // Reset input fields
    }
}
