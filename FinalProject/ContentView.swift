//
//  ContentView 2.swift
//  FinalProject
//
//  Created by Ashley Cardot on 12/13/24.
//


import SwiftUI

struct ContentView: View {
    @State private var availablePoses: [YogaPose] = [
        YogaPose(
            id: UUID(),
            name: "downdog",  // Exact name as in ML model
            description: "A pose that stretches and strengthens the entire body",
            difficulty: .beginner,
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
            name: "goddess",  // Exact name as in ML model
            description: "A powerful standing pose that opens the hips",
            difficulty: .intermediate,
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
            name: "plank",  // Exact name as in ML model
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
            name: "tree",  // Exact name as in ML model
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
            name: "warrior2",  // Exact name as in ML model
            description: "A standing pose that builds strength and stability",
            difficulty: .beginner,
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

    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Text("My YOGI")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .font(.custom("Arial Rounded MT Bold", size: 48))
                    .foregroundColor(.blue)
                    .multilineTextAlignment(.center)

                NavigationLink(
                    destination: PoseSelectionView(availablePoses: $availablePoses)
                ) {
                    HStack {
                        Image(systemName: "figure.walk")
                            .font(.title2)
                        Text("Practice")
                            .fontWeight(.bold)
                    }
                    .padding()
                    .frame(maxWidth: 200)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }

                NavigationLink(
                    destination: PoseLearnView(availablePoses: availablePoses)
                ) {
                    HStack {
                        Image(systemName: "figure.mind.and.body")
                            .font(.title2)
                        Text("Learn")
                            .fontWeight(.bold)
                    }
                    .padding()
                    .frame(maxWidth: 200)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }

                NavigationLink(
                    destination: FavoritesView(availablePoses: $availablePoses)
                ) {
                    HStack {
                        Image(systemName: "star.fill")
                            .font(.title2)
                        Text("Favorites")
                            .fontWeight(.bold)
                    }
                    .padding()
                    .frame(maxWidth: 200)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .opacity(hasFavorites ? 1.0 : 0.5)
                }
                .disabled(!hasFavorites)

                Spacer()
            }
            .padding()
        }
    }
}
