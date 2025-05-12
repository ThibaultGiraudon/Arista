struct TrendCard: View {
    let title: String
    let value: String
    let unit: String?
    let color: Color

    var body: some View {
        HStack {
            Image(systemName: "minus")
                .padding(15)
                .font(.title.bold())
                .foregroundStyle(color)
                .background(Circle().fill(color.opacity(0.1)))
            VStack(alignment: .leading) {
                Text(title)
                HStack(spacing: 2) {
                    Text(value)
                        .font(.headline.bold())
                    if let unit = unit {
                        Text(unit)
                            .font(.subheadline.bold())
                    }
                }
                .foregroundStyle(color)
            }
        }
    }
}