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
            if selectedView == .list {
                addEntryButton
            }
        }
        .navigationTitle(exercise.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if selectedView == .list {
                    EditButton()
                }
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
            ForEach(exercise.entries.sorted(by: { $0.date > $1.date })) { entry in
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
                            Text("Kg")
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
        //.scrollContentBackground(.hidden)
        .background(Color.white)
    }

    private var chartView: some View {
        // 1) Pre-calculate stats
        let weights = exercise.entries.map { $0.weight }
        let maxWeight = weights.max() ?? 0
        let averageWeight = weights.isEmpty ? 0 : weights.reduce(0, +) / Double(weights.count)
        let totalWeight = weights.reduce(0, +) // Sum of raw weights; if you want training volume, multiply reps*sets*weight.
        let POL = maxWeight * 1.05

        return GeometryReader { geometry in
            VStack {
                // 2) The Chart (with horizontal scroll if needed)
                ScrollView(.horizontal, showsIndicators: false) {
                    Chart {
                        // Plot each data point
                        ForEach(Array(exercise.entries.enumerated()), id: \.offset) { index, entry in
                            LineMark(
                                x: .value("Index", index),
                                y: .value("Weight", entry.weight)
                            )
                            .interpolationMethod(.catmullRom)
                            .foregroundStyle(
                                LinearGradient(
                                    gradient: Gradient(colors: [.black, .black]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            
                            PointMark(
                                x: .value("Index", index),
                                y: .value("Weight", entry.weight)
                            )
                            .symbolSize(50)
                            .foregroundStyle(.black)
                            .annotation(position: .top) {
                                Text("\(entry.weight, specifier: "%.1f") kg")
                                    .font(.caption)
                                    .foregroundColor(.black)
                            }
                        }
                        
                        // A horizontal "average weight" line
                        RuleMark(y: .value("Average", averageWeight))
                            .foregroundStyle(.blue)
                            .lineStyle(StrokeStyle(lineWidth: 2, dash: [6]))
                            .annotation(position: .top, alignment: .leading) {
                                Text("Avg: \(averageWeight, specifier: "%.1f") kg")
                                    .foregroundColor(.blue)
                                    .font(.caption2)
                            }
                    }
                    // Pin Y-axis to the left
                    .chartYAxis {
                        //AxisMarks(position: .leading)
                    }
                    // Use Array(...) for X-axis values to avoid range conversion errors
                    .chartXAxis {
                        AxisMarks(values: Array(0 ..< exercise.entries.count)) { value in
                            AxisTick()
                            AxisGridLine()
                            /*AxisValueLabel {
                                if let index = value.as(Int.self),
                                   index < exercise.entries.count {
                                    Text(exercise.entries[index].date, style: .date)
                                }
                            }*/
                        }
                    }
                    // Force minimum width and scroll if data is wide
                    .frame(
                        width: max(geometry.size.width, CGFloat(exercise.entries.count) * 60),
                        height: 300
                    )
                    .padding()
                }
                
                Text("Statistics")
                
                // 3) The Stat Tiles
                HStack(spacing: 8) {
                    statTile(title: "Max Weight", value: maxWeight)
                    statTile(title: "Overload", value: POL)
                }
                .frame(height: 100)       // Adjust the tile height as needed
                .padding(.horizontal, 16)
                
                HStack(spacing: 8) {
                    statTile(title: "Average Weight", value: averageWeight)
                    statTile(title: "Total Weight", value: totalWeight)
                }
                .frame(height: 100)       // Adjust the tile height as needed
                .padding(.horizontal, 16) // Horizontal padding for the row
            }
        }
        // Extra space for chart + tiles
        .frame(height: 450)
    }
    
    /// A reusable square tile showing a title and a numeric value.
    private func statTile(title: String, value: Double) -> some View {
        VStack(spacing: 8) {
            Text("\(value, specifier: "%.1f")")
                .font(.title)
                .fontWeight(.bold)
            Text(title)
                .font(.subheadline)
                .foregroundColor(Color.black)
        }
        .frame(maxWidth: .infinity)                // Each tile expands equally in the HStack
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray, lineWidth: 2)
        )
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
            AddEntryView(
                exercise: exercise,
                onSave: { newEntry in
                    guard let exerciseIndex = viewModel.exercises.firstIndex(where: { $0.id == exercise.id }) else { return }
                    viewModel.exercises[exerciseIndex].entries.append(newEntry)
                    PersistenceManager.saveExercises(viewModel.exercises)
                    isAddingEntry = false
                }
            )
        }
    }

    // MARK: - Methods

    private func deleteEntry(at offsets: IndexSet) {
        guard let exerciseIndex = viewModel.exercises.firstIndex(where: { $0.id == exercise.id }) else { return }
        viewModel.exercises[exerciseIndex].entries.remove(atOffsets: offsets)
        PersistenceManager.saveExercises(viewModel.exercises)
    }
}

struct ExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        let mockViewModel = ModelsViewModel()
        let mockExercise = Exercise(
            name: "Mock Exercise",
            entries: [
                ExerciseEntry(name: "Mock Entry 1", reps: 10, sets: 3, weight: 50.0, date: Date()),
                ExerciseEntry(name: "Mock Entry 2", reps: 8, sets: 4, weight: 55.0, date: Date().addingTimeInterval(-86400))
            ]
        )
        return NavigationView {
            ExerciseView(viewModel: mockViewModel, exercise: mockExercise)
        }
    }
}
