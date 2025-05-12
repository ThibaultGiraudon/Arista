struct ExerciseSummaryCard: View {
    @ObservedObject var viewModel: ExerciseListViewModel

    var body: some View {
        NavigationLink {
            ExerciseListView(viewModel: viewModel)
        } label: {
            VStack(alignment: .leading) {
                let lastExercise = viewModel.exercises.last

                HeaderRow(icon: "flame.fill", title: "Activité", date: lastExercise?.date)
                    .foregroundStyle(.red)

                if let exercise = lastExercise {
                    HStack {
                        Image(systemName: exercise.categoryItem.icon)
                            .font(.largeTitle)
                        VStack(alignment: .leading) {
                            Text(exercise.category ?? "")
                            HStack {
                                Text("\(exercise.duration)")
                                    .font(.title.bold())
                                Text("min")
                            }
                        }
                    }
                } else {
                    Text("Ajouter un premier exercice")
                }
            }
            .cardBackground()
        }
    }
}