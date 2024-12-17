import SwiftUI

struct ContentView: View {
    @State private var availablePoses: [YogaPose] = [
        YogaPose(
            id: UUID(),
            name: "downdog",
            description: "A pose that stretches and strengthens the entire body",
            difficulty: .intermediate,
            instructions: [
                "Start on hands and knees",
                "Lift your knees off the floor",
                "Straighten your legs and arms",
                "Push your heels toward the ground",
                "Keep your head between your arms"
            ],
            mediaURL: URL(string: "placeholder")!,
            isVideo: false,
            isFavorite: false
        ),
        YogaPose(
            id: UUID(),
            name: "goddess",
            description: "A powerful standing pose that opens the hips",
            difficulty: .advanced,
            instructions: [
                "Step feet wide apart",
                "Turn toes out 45 degrees",
                "Bend knees over ankles",
                "Raise arms to shoulder height",
                "Keep spine straight"
            ],
            mediaURL: URL(string: "placeholder")!,
            isVideo: false,
            isFavorite: false
        ),
        YogaPose(
            id: UUID(),
            name: "plank",
            description: "A core strengthening pose that builds stability",
            difficulty: .beginner,
            instructions: [
                "Start in push-up position",
                "Keep body in straight line",
                "Engage core muscles",
                "Keep shoulders over wrists",
                "Look slightly forward"
            ],
            mediaURL: URL(string: "placeholder")!,
            isVideo: false,
            isFavorite: false
        ),
        YogaPose(
            id: UUID(),
            name: "tree",
            description: "A balancing pose that improves focus and stability",
            difficulty: .beginner,
            instructions: [
                "Stand on one leg",
                "Place other foot on inner thigh or calf",
                "Never place foot on knee",
                "Bring hands to heart center",
                "Fix gaze on steady point"
            ],
            mediaURL: URL(string: "placeholder")!,
            isVideo: false,
            isFavorite: false
        ),
        YogaPose(
            id: UUID(),
            name: "warrior2",
            description: "A standing pose that builds strength and stability",
            difficulty: .intermediate,
            instructions: [
                "Step feet wide apart",
                "Turn front foot out 90 degrees",
                "Bend front knee over ankle",
                "Extend arms parallel to ground",
                "Gaze over front hand"
            ],
            mediaURL: URL(string: "placeholder")!,
            isVideo: false,
            isFavorite: false
        )
    ]
    
    var hasFavorites: Bool {
        availablePoses.contains { $0.isFavorite }
    }
    
    var backgroundGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(hex: "1a365d"),  // Deep blue
                Color(hex: "2c5282")   // Medium blue
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    var body: some View {
        NavigationView {
            ZStack {
                backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 35) {
                    // Logo and Title Area
                    VStack(spacing: 10) {
                        Image(systemName: "figure.yoga")
                            .font(.system(size: 60))
                            .foregroundColor(.white)
                        
                        Text("My YOGI")
                            .font(.system(size: 42, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                    }
                    .padding(.top, 50)
                    
                    // Menu Options
                    VStack(spacing: 20) {
                        MenuButton(
                            title: "Practice",
                            icon: "figure.walk",
                            color: Color(hex: "4299e1")  // Bright blue
                        ) {
                            PoseSelectionView(availablePoses: $availablePoses, mode: .practice)
                        }
                        
                        MenuButton(
                            title: "Learn",
                            icon: "book.fill",
                            color: Color(hex: "3182ce")  // Medium bright blue
                        ) {
                            PoseSelectionView(availablePoses: $availablePoses, mode: .learn)
                        }
                        
                        MenuButton(
                            title: "Favorites",
                            icon: "star.fill",
                            color: Color(hex: "2b6cb0"),  // Darker blue
                            isDisabled: !hasFavorites
                        ) {
                            PoseSelectionView(availablePoses: $availablePoses, mode: .favorites)
                        }
                    }
                    .padding(.horizontal, 30)
                    
                    Spacer()
                    
                    // Footer
                    Text("Start your yoga journey today")
                        .font(.system(.body, design: .rounded))
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.bottom, 20)
                }
            }
        }
    }
}

struct MenuButton<Destination: View>: View {
    let title: String
    let icon: String
    let color: Color
    let destination: Destination
    var isDisabled: Bool = false
    
    init(
        title: String,
        icon: String,
        color: Color,
        isDisabled: Bool = false,
        @ViewBuilder destination: () -> Destination
    ) {
        self.title = title
        self.icon = icon
        self.color = color
        self.isDisabled = isDisabled
        self.destination = destination()
    }
    
    var body: some View {
        NavigationLink(destination: destination) {
            HStack(spacing: 15) {
                Image(systemName: icon)
                    .font(.title2)
                Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .opacity(0.7)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(color)
            .foregroundColor(.white)
            .cornerRadius(16)
            .shadow(color: color.opacity(0.3), radius: 10, x: 0, y: 5)
            .opacity(isDisabled ? 0.5 : 1.0)
        }
        .disabled(isDisabled)
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
