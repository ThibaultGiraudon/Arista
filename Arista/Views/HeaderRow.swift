struct HeaderRow: View {
    let icon: String
    let title: String
    let date: Date?

    var body: some View {
        HStack {
            Image(systemName: icon)
            Text(title)
            Spacer()
            Text(date?.formatted(date: .abbreviated, time: .omitted) ?? "")
                .foregroundStyle(.gray)
            Image(systemName: "chevron.right")
                .foregroundStyle(.gray)
                .font(.footnote)
        }
        .font(.title2)
    }
}