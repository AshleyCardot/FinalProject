import Foundation
import SwiftUI

struct PoseSelectionView: View {
    @Binding var availablePoses: [YogaPose]
    let mode: ViewMode
    @State private var searchText = ""
    @State private var selectedDifficulty: Difficulty?
    
    enum ViewMode {
        case practice
        case learn
        case favorites
    }
    
    enum Difficulty: String, CaseIterable {
        case beginner
        case intermediate
        case advanced
    }
    
    private let poseImages: [String: String] = [
        "downdog": "downdog-preview",
        "goddess": "goddess-preview",
        "plank": "plank-preview",
        "tree": "tree-preview",
        "warrior2": "warrior2-preview"
    ]
    
    private var displayedPoses: [YogaPose] {
        var poses = mode == .favorites ? availablePoses.filter { $0.isFavorite } : availablePoses
        
        if let difficulty = selectedDifficulty {
            poses = poses.filter { $0.difficulty.rawValue == difficulty.rawValue }
        }
        
        if !searchText.isEmpty {
            poses = poses.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        
        return poses
    }
    
    private var titleText: String {
        switch mode {
        case .practice: return "Practice Poses"
        case .learn: return "Learn Poses"
        case .favorites: return "Favorites"
        }
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 20) {
                    // Search Bar
                    SearchBar(text: $searchText)
                        .padding(.horizontal)
                    
                    // Difficulty Filter
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(Difficulty.allCases, id: \.self) { difficulty in
                                DifficultyFilterButton(
                                    difficulty: difficulty,
                                    isSelected: selectedDifficulty == difficulty,
                                    action: {
                                        withAnimation {
                                            if selectedDifficulty == difficulty {
                                                selectedDifficulty = nil
                                            } else {
                                                selectedDifficulty = difficulty
                                            }
                                        }
                                    }
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Responsive Grid
                    let columns = geometry.size.width > 500 ? [
                        GridItem(.flexible(), spacing: 16),
                        GridItem(.flexible(), spacing: 16)
                    ] : [
                        GridItem(.flexible(), spacing: 16)
                    ]
                    
                    LazyVGrid(
                        columns: columns,
                        spacing: 16
                    ) {
                        ForEach(displayedPoses.indices, id: \.self) { index in
                            let pose = displayedPoses[index]
                            let mainIndex = availablePoses.firstIndex(where: { $0.id == pose.id }) ?? index
                            
                            PoseCard(
                                pose: pose,
                                imageName: poseImages[pose.name] ?? "",
                                mode: mode,
                                isFavorite: pose.isFavorite,
                                onFavorite: {
                                    withAnimation {
                                        availablePoses[mainIndex].isFavorite.toggle()
                                    }
                                }
                            )
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle(titleText)
            .background(Color(.systemGroupedBackground))
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search poses", text: $text)
                .textFieldStyle(PlainTextFieldStyle())
            
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(10)
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct DifficultyFilterButton: View {
    let difficulty: PoseSelectionView.Difficulty
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(difficulty.rawValue.capitalized)
                .font(.system(.subheadline, design: .rounded))
                .fontWeight(.medium)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(isSelected ? difficultyColor : Color(.systemBackground))
                )
                .foregroundColor(isSelected ? .white : difficultyColor)
                .overlay(
                    Capsule()
                        .strokeBorder(difficultyColor, lineWidth: isSelected ? 0 : 1)
                )
        }
    }
    
    private var difficultyColor: Color {
        switch difficulty {
        case .beginner: return .green
        case .intermediate: return .orange
        case .advanced: return .red
        }
    }
}

struct PoseCard: View {
    let pose: YogaPose
    let imageName: String
    let mode: PoseSelectionView.ViewMode
    let isFavorite: Bool
    let onFavorite: () -> Void
    
    var body: some View {
        NavigationLink(
            destination: mode == .learn ?
                AnyView(LearnPosesView(selectedPose: pose)) :
                AnyView(LivePoseFeedbackView(selectedPose: pose))
        ) {
            VStack(alignment: .leading, spacing: 0) {
                // Image Container
                ZStack(alignment: .topTrailing) {
                    if let uiImage = UIImage(named: imageName) ?? UIImage(contentsOfFile: Bundle.main.path(forResource: imageName, ofType: "jpg") ?? "") {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 200)
                            .clipped()
                    } else {
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 160)
                            .overlay(
                                Text("Image not found")
                                    .foregroundColor(.gray)
                            )
                    }
                    
                    // Difficulty badge
                    Text(pose.difficulty.rawValue.capitalized)
                        .font(.system(.caption, design: .rounded))
                        .fontWeight(.medium)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(difficultyColor.opacity(0.9))
                        )
                        .foregroundColor(.white)
                        .padding(8)
                }
                .frame(maxWidth: .infinity)
                .cornerRadius(16, corners: [.topLeft, .topRight])
                
                // Content container
                VStack(alignment: .leading, spacing: 8) {
                    Text(pose.name.capitalized)
                        .font(.system(.headline, design: .rounded))
                        .lineLimit(1)
                    
                    Text(pose.description)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineLimit(2)
                        .frame(height: 40)
                    
                    // Favorite Button
                    Button(action: onFavorite) {
                        HStack {
                            Image(systemName: isFavorite ? "star.fill" : "star")
                            Text(isFavorite ? "Favorited" : "Favorite")
                                .font(.system(.caption, design: .rounded))
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(isFavorite ? Color.yellow.opacity(0.2) : Color.blue.opacity(0.1))
                        )
                        .foregroundColor(isFavorite ? .orange : .blue)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
                .padding(12)
                .frame(height: 120)
            }
            .frame(maxWidth: .infinity)
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
    }
    
    private var difficultyColor: Color {
        switch pose.difficulty {
        case .beginner: return .green
        case .intermediate: return .orange
        case .advanced: return .red
        }
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
