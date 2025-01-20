import SwiftUI
import Charts // Import Charts for diagram view

struct ExerciseView: View {
    @ObservedObject var viewModel: ModelsViewModel
    let exercise: Exercise
    @State private var isAddingEntry = false
    @State private var selectedView: ViewMode = .list // Track the selected view (list or chart)

    enum ViewMode: String, CaseIterable, Identifiable {
        case list = "List"
        case chart = "Diagram"
        var id: String { self.rawValue }
    }

    var body: some View {
        VStack {
            // View Selector
            viewSelector

            // Conditional Views
            if exercise.entries.isEmpty {
                placeholderView
            } else {
                if selectedView == .list {
                    listView
                } else {
                    chartView
                }
            }

            Spacer()

            // Add Entry Button
            addEntryButton
        }
        .navigationTitle(exercise.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
        }
    }

    // MARK: - Subviews

    private var viewSelector: some View {
        Picker("View Mode", selection: $selectedView) {
            ForEach(ViewMode.allCases) { mode in
                Text(mode.rawValue).tag(mode)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding()
    }

    private var placeholderView: some View {
        Text("No entries yet. Add your first entry!")
            .foregroundColor(.gray)
            .font(.headline)
            .multilineTextAlignment(.center)
            .padding()
    }

    private var listView: some View {
        List {
            ForEach(exercise.entries) { entry in
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 32) {
                        VStack(spacing: 4) {
                            Text("\(entry.reps)")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            Text("Reps")
                                .font(.callout)
                                .foregroundColor(.black)
                        }
                        Spacer()
                        VStack(spacing: 4) {
                            Text("\(entry.sets)")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            Text("Sets")
                                .font(.callout)
                                .foregroundColor(.black)
                        }
                        Spacer()
                        VStack(spacing: 4) {
                            Text("\(String(format: "%.1f", entry.weight))")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            Text("Weight (kg)")
                                .font(.callout)
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.vertical, 2)
                    HStack(spacing: 8) {
                        Text(entry.date, style: .date)
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal, 4.0)
                .padding(.vertical, 8)
            }
            .onDelete(perform: deleteEntry)
        }
    }

    private var chartView: some View {
        Chart {
            ForEach(Array(exercise.entries.enumerated()), id: \.offset) { index, entry in
                LineMark(
                    x: .value("Index", index + 1),
                    y: .value("Weight", entry.weight)
                )
                .interpolationMethod(.catmullRom) // Smooth rounded line
                .foregroundStyle(LinearGradient(
                    gradient: Gradient(colors: [Color.blue, Color.purple]),
                    startPoint: .leading,
                    endPoint: .trailing
                ))
            }
        }
        .chartXAxis {
            AxisMarks(values: .stride(by: 1)) { value in
                if let index = value.as(Int.self) {
                    AxisValueLabel("Entry \(index)") // Show "Entry 1", "Entry 2", etc.
                }
            }
        }
        .padding()
    }

    private var addEntryButton: some View {
        Button(action: { isAddingEntry = true }) {
            Text("Add Entry")
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
        .padding()
        .sheet(isPresented: $isAddingEntry) {
            AddEntryView(viewModel: viewModel, exercise: exercise)
        }
    }

    // MARK: - Methods

    private func deleteEntry(at offsets: IndexSet) {
        guard let exerciseIndex = viewModel.exercises.firstIndex(where: { $0.id == exercise.id }) else { return }
        viewModel.exercises[exerciseIndex].entries.remove(atOffsets: offsets)
        PersistenceManager.saveExercises(viewModel.exercises)
    }
}
