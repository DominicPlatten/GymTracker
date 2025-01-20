import SwiftUI

struct ExerciseTile: View {
    let exercise: Exercise

    var body: some View {
        VStack(alignment: .leading) {
            Text(exercise.name)
                .font(.headline)
            
            if let latestEntry = exercise.entries.last {
                HStack {
                    Text("Reps: \(latestEntry.reps)")
                    Text("Sets: \(latestEntry.sets)")
                    Text("Weight: \(String(format: "%.1f", latestEntry.weight)) kg")
                }
                .font(.subheadline)
                .foregroundColor(.gray)
            } else {
                Text("No entries yet")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(8)
    }
}

#Preview {
    ExerciseTile(exercise: Exercise(
        name: "Push-ups",
        entries: [
        ]
    ))
}
