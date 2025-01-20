import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ModelsViewModel()
    @State private var isAddingExercise = false
    @State private var isAddingWorkout = false

    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGray6)
                    .ignoresSafeArea()

                VStack {
                    if !viewModel.exercises.isEmpty || !viewModel.workouts.isEmpty {
                        List {
                            Section(header: Text("Workouts")) {
                                ForEach(viewModel.workouts) { workout in
                                    NavigationLink(destination: WorkoutDetailView(viewModel: viewModel, workout: workout)) {
                                        Text(workout.name)
                                    }
                                }
                            }

                            Section(header: Text("Exercises")) {
                                ForEach(viewModel.exercises) { exercise in
                                    NavigationLink(destination: ExerciseView(viewModel: viewModel, exercise: exercise)) {
                                        Text(exercise.name)
                                    }
                                }
                                .onDelete(perform: viewModel.deleteExercise(at:))
                            }
                        }
                    } else {
                        Text("No data yet. Add exercises or workouts to get started!")
                            .foregroundColor(.gray)
                    }

                    Spacer()

                    HStack {
                        Button(action: { isAddingExercise = true }) {
                            Text("Add Exercise")
                        }
                        .buttonStyle(CustomButtonStyle())
                        .sheet(isPresented: $isAddingExercise) {
                            AddExerciseSheet(viewModel: viewModel, isAddingExercise: $isAddingExercise)
                        }

                        Button(action: { isAddingWorkout = true }) {
                            Text("Add Workout")
                        }
                        .buttonStyle(CustomButtonStyle())
                        .sheet(isPresented: $isAddingWorkout) {
                            AddWorkoutSheet(viewModel: viewModel, isAddingWorkout: $isAddingWorkout)
                        }
                    }
                    .padding()
                }
                .navigationTitle("Gym Tracker ✌️")
            }
        }
    }
}

#Preview {
    ContentView()
}
