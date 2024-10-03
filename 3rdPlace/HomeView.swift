import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea() // Black background
                
                VStack(spacing: 20) {
                    // Top Navbar with logo placeholder
                    HStack {
                        Spacer()
                        Text("LOGO") // Placeholder for aesthetic logo
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                        Spacer()
                    }
                    .background(Color.gray.opacity(0.2)) // Modern translucent navbar
                    
                    // ScrollView that includes the heatmap and carousels
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 30) {
                            // Heatmap placeholder (1/4 of the screen) inside the ScrollView
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: UIScreen.main.bounds.height / 4)
                                .overlay(
                                    Text("Heatmap Placeholder")
                                        .foregroundColor(.white)
                                        .font(.headline)
                                )
                                .padding(.horizontal)
                            
                            // "People" Carousel
                            CarouselView(title: "People")
                            
                            // "My Spots" Carousel
                            CarouselView(title: "My Spots")
                            
                            // "Places" Carousel
                            CarouselView(title: "Places")
                        }
                        .padding(.horizontal)
                    }
                    
                    // Bottom Navbar
                    HStack {
                        Spacer()
                        BottomNavBarItem(iconName: "person.2.fill", label: "Friends")
                        Spacer()
                        
                        // NavigationLink for the Settings button
                        NavigationLink(destination: SettingsView()) {
                            BottomNavBarItem(iconName: "gearshape.fill", label: "Settings")
                        }
                        
                        Spacer()
                        BottomNavBarItem(iconName: "map.fill", label: "Places")
                        Spacer()
                        BottomNavBarItem(iconName: "message.fill", label: "Missed Connections")
                        Spacer()
                    }
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(20)
                }
            }
        }
    }
}

struct CarouselView: View {
    var title: String
    @State private var scrollOffset: CGFloat = 0 // Track scroll position
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title2)
                .bold()
                .foregroundColor(.white)
                .padding(.leading)
            
            ZStack {
                // Arrows and Carousel
                HStack {
                    // Left arrow button
                    Button(action: {
                        withAnimation {
                            scrollOffset += 150 // Scroll left
                        }
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .frame(width: 18, height: 18)
                            .background(Color.gray.opacity(0.3))
                            .clipShape(Circle()) // Smaller and more transparent
                            .shadow(radius: 2) // Add a small shadow to elevate slightly
                    }
                    .padding(.leading, -25) // Move the arrow further from the content
                    .opacity(0.6) // Make it more subtle
                    
                    // ScrollView with dynamic scrollOffset
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(0..<10) { _ in
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.blue.opacity(0.7))
                                    .frame(width: 150, height: 100)
                                    .overlay(
                                        Text("Placeholder")
                                            .foregroundColor(.white)
                                            .font(.headline)
                                    )
                                    .shadow(color: Color.blue.opacity(0.5), radius: 10, x: 0, y: 5)
                            }
                        }
                        .padding(.horizontal, 20)
                        .offset(x: scrollOffset) // Adjust horizontal scroll using offset
                    }
                    
                    // Right arrow button
                    Button(action: {
                        withAnimation {
                            scrollOffset -= 150 // Scroll right
                        }
                    }) {
                        Image(systemName: "chevron.right")
                            .foregroundColor(.white)
                            .frame(width: 18, height: 18)
                            .background(Color.gray.opacity(0.3))
                            .clipShape(Circle()) // Sleek circular button
                            .shadow(radius: 2)
                    }
                    .padding(.trailing, -25) // Move the arrow further from the content
                    .opacity(0.6) // More subtle opacity
                }
            }
            .padding(.horizontal)
        }
    }
}

struct BottomNavBarItem: View {
    var iconName: String
    var label: String
    
    var body: some View {
        VStack {
            Image(systemName: iconName)
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(.white) // White icon
            Text(label)
                .font(.caption)
                .foregroundColor(.white) // White label
        }
    }
}

#Preview {
    HomeView()
}
