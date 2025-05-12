struct CaloriesCard: View {
    let calories: Int

    var body: some View {
        VStack(alignment: .leading) {
            HeaderRow(icon: "flame.fill", title: "Calories", date: Date())
                .foregroundStyle(.red)
            HStack {
                Text("\(calories)")
                    .font(.largeTitle.bold())
                Text("kcal")
            }
        }
        .cardBackground()
    }
}