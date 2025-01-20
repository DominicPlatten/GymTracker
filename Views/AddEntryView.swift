import SwiftUI

struct AddEntryView: View {
    @ObservedObject var viewModel: ModelsViewModel
    let exercise: Exercise
    @Environment(\.dismiss) var dismiss

    @State private var entryName: String = "" 
    @State private var reps: Int = 0
    @State private var sets: Int = 0
    @State private var weight: Double = 0.0

    var body: some View {
        NavigationView {
            Form {
                TextField("Entry Name", text: $entryName) // Input for entry name

                Stepper("Reps: \(reps)", value: $reps, in: 0...100)
                Stepper("Sets: \(sets)", value: $sets, in: 0...20)

                VStack {
                    Text("Weight: \(String(format: "%.1f", weight)) kg")
                    Slider(value: $weight, in: 0...200, step: 0.5)
                }
            }
            .navigationTitle("Add Entry")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        viewModel.addEntry(toExerciseId: exercise.id, name: entryName, reps: reps, sets: sets, weight: weight)
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    AddEntryView(viewModel: ModelsViewModel(), exercise: Exercise(name: "Bench Press"))
}
