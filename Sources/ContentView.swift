import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 12) {
            Text("FINDR")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("지금의 나에게 맞는 기회를 찾다.")
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
