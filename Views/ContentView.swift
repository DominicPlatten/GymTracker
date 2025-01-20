import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ModelsViewModel()
    @State private var isAddingExercise = false
    @State private var isAddingWorkout = false
    @State private var isEditing = false
    @State private var showDeleteConfirmation = false
    @State private var itemToDelete: Any? = nil // Holds the item to delete
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGray6)
                    .ignoresSafeArea()
                
                VStack {
                    ContentListView(
                        viewModel: viewModel,
                        isEditing: $isEditing,
                        itemToDelete: $itemToDelete,
                        showDeleteConfirmation: $showDeleteConfirmation,
                        isAddingExercise: $isAddingExercise,
                        isAddingWorkout: $isAddingWorkout
                    )
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { isEditing.toggle() }) {
                        Text(isEditing ? "Done" : "Edit")
                    }
                }
            }
            .confirmationDialog("Are you sure you want to delete this item?", isPresented: $showDeleteConfirmation, titleVisibility: .visible) {
                Button("Delete", role: .destructive) {
                    deleteSelectedItem()
                }
                Button("Cancel", role: .cancel) {
                    itemToDelete = nil
                }
            }
        }
    }
    
    private func deleteSelectedItem() {
        if let workout = itemToDelete as? Workout {
            viewModel.deleteWorkout(workout)
        } else if let exercise = itemToDelete as? Exercise {
            if let index = viewModel.exercises.firstIndex(where: { $0.id == exercise.id }) {
                viewModel.deleteExercise(at: IndexSet(integer: index))
            }
        }
        itemToDelete = nil
    }
}

struct ContentListView: View {
    @ObservedObject var viewModel: ModelsViewModel
    @Binding var isEditing: Bool
    @Binding var itemToDelete: Any?
    @Binding var showDeleteConfirmation: Bool
    @Binding var isAddingExercise: Bool
    @Binding var isAddingWorkout: Bool
    
    var body: some View {
        if !viewModel.exercises.isEmpty || !viewModel.workouts.isEmpty {
            List {
                Section(header: Text("WORKOUTS")
                            .font(.title2)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.bottom, 0)) {
                    ForEach(viewModel.workouts) { workout in
                        HStack {
                            NavigationLink(destination: WorkoutDetailView(viewModel: viewModel, workout: workout)) {
                                Text(workout.name)
                            }
                            if isEditing {
                                Spacer()
                                DeleteButton {
                                    itemToDelete = workout
                                    showDeleteConfirmation = true
                                }
                            }
                        }
                    }
                    
                    Button(action: {isAddingWorkout = true}) {
                        Text("Add")
                            .fontWeight(.regular)
                            .buttonStyle(PlainButtonStyle())
                            .sheet(isPresented: $isAddingWorkout) {
                                AddWorkoutSheet(viewModel: viewModel, isAddingWorkout: $isAddingWorkout)
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                
                Section(header: Text("EXERCISES")
                            .font(.title2)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.bottom, 0)) {
                    ForEach(viewModel.exercises) { exercise in
                        HStack {
                            NavigationLink(destination: ExerciseView(viewModel: viewModel, exercise: exercise)) {
                                Text(exercise.name)
                            }
                            if isEditing {
                                Spacer()
                                DeleteButton {
                                    itemToDelete = exercise
                                    showDeleteConfirmation = true
                                }
                            }
                        }
                    }
            
                    Button(action: { isAddingExercise = true }) {
                        Text("Add")
                            .fontWeight(.regular)
                            .sheet(isPresented: $isAddingExercise) {
                                AddExerciseSheet(viewModel: viewModel, isAddingExercise: $isAddingExercise)
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
        } else {
            Text("No data yet. Add exercises or workouts to get started!")
                .foregroundColor(.gray)
        }
    }
}

struct DeleteButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "trash")
                .foregroundColor(.red)
        }
        .buttonStyle(BorderlessButtonStyle())
    }
}

#Preview {
    ContentView()
}
