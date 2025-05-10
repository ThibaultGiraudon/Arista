import SwiftUI

struct TransitionsBootCamp: View {
    
    @State private var isShow: Bool = false
    
    // MARK: - Body
    var body: some View {
        VStack {
            Text("Transitions")
                .font(.system(.title, weight: .bold))
            if isShow {
                imageView
                    .transition(.slide)
                imageView
                    .transition(.opacity)
                imageView
                    .transition(.scale)
                imageView
                    .transition(.scale.combined(with: .slide))
                imageView
                    .transition(.asymmetric(insertion: .slide, removal: .scale))
                imageView
                    .transition(.move(edge: .top))
            }
            Spacer()
            Button {
                withAnimation {
                    isShow.toggle()
                }
            } label: {
                Text("Show")
                    .foregroundColor(.white)
                    .padding(.vertical, 15)
                    .padding(.horizontal, 25)
                    .background(Color.blue)
                    .clipShape(Capsule())
            }
        }
    }
    
    @ViewBuilder
    private var imageView: some View {
        Image("swiftui")
            .resizable()
            .scaledToFit()
            .frame(width: 100, height: 100)
    }
}

#Preview {
    TransitionsBootCamp()
        .preferredColorScheme(.dark)
}