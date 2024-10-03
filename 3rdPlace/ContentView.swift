import SwiftUI

struct ContentView: View {
    @State private var isAnimating = false
    @State private var isLoadingComplete = false
    @State private var isLoggedIn = false // Replace with actual login state logic

    var body: some View {
        if isLoadingComplete {
            // Navigate to either LoginView or HomeView based on login state
            if isLoggedIn {
                HomeView() // Show HomeView if logged in
            } else {
                LoginView() // Show LogInView if not logged in
            }
        } else {
            ZStack {
                Color.black
                    .ignoresSafeArea() // Ensures the background covers the whole screen
                
                VStack {
                    Text("3RD PLACE ;)")
                        .font(.system(size: 50, weight: .bold))
                        .foregroundColor(.white)
                        .padding()

                    // Loading dots animation
                    HStack(spacing: 8) {
                        ForEach(0..<3) { index in
                            Circle()
                                .frame(width: 15, height: 15)
                                .foregroundColor(.white)
                                .scaleEffect(isAnimating ? 1.0 : 0.5)
                                .animation(
                                    Animation.easeInOut(duration: 0.6)
                                        .repeatForever()
                                        .delay(Double(index) * 0.2),
                                    value: isAnimating
                                )
                        }
                    }
                    .padding(.top, 20)
                    .onAppear {
                        isAnimating = true
                        
                        // Simulate loading time (e.g., 3 seconds), then transition
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            isLoadingComplete = true
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
