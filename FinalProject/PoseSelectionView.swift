import Foundation
import SwiftUI

struct PoseSelectionView: View {
    @Binding var availablePoses: [YogaPose]
    let mode: ViewMode
    
    enum ViewMode {
        case practice
        case learn
        case favorites
    }
    
    private let poseImages: [String: String] = [
        "downdog": "downdog-preview",
        "goddess": "goddess-preview",
        "plank": "plank-preview",
        "tree": "tree-preview",
        "warrior2": "warrior2-preview"
    ]
    
    private var displayedPoses: [YogaPose] {
        mode == .favorites ? availablePoses.filter { $0.isFavorite } : availablePoses
    }

    var body: some View {
        List {
            ForEach(displayedPoses.indices, id: \.self) { index in
                let pose = displayedPoses[index]
                // Find the actual index in availablePoses for favoriting
                let mainIndex = availablePoses.firstIndex(where: { $0.id == pose.id }) ?? index
                
                NavigationLink(
                    destination: mode == .learn ?
                        AnyView(LearnPosesView(selectedPose: pose)) :
                        AnyView(LivePoseFeedbackView(selectedPose: pose))
                ) {
                    VStack(alignment: .leading, spacing: 12) {
                        if let imageName = poseImages[pose.name],
                           let uiImage = UIImage(named: imageName) ?? UIImage(contentsOfFile: Bundle.main.path(forResource: imageName, ofType: "jpg") ?? "") {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(16/9, contentMode: .fill)
                                .frame(height: 200)
                                .clipped()
                                .cornerRadius(8)
                        } else {
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 150)
                                .cornerRadius(8)
                                .overlay(
                                    Text("Image not found: \(poseImages[pose.name] ?? "unknown")")
                                        .foregroundColor(.gray)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text(pose.name.capitalized)
                                    .font(.headline)
                                Spacer()
                                Text(pose.difficulty.rawValue.capitalized)
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(
                                        Capsule()
                                            .fill(pose.difficulty == .beginner ? Color.green.opacity(0.2) : Color.orange.opacity(0.2))
                                    )
                            }
                            
                            Text(pose.description)
                                .font(.subheadline)
                                .foregroundColor(.gray)

                            Button(action: {
                                availablePoses[mainIndex].isFavorite.toggle()
                            }) {
                                HStack {
                                    Image(systemName: pose.isFavorite ? "star.fill" : "star")
                                        .foregroundColor(pose.isFavorite ? .yellow : .blue)
                                    Text(pose.isFavorite ? "Unfavorite" : "Favorite")
                                        .font(.subheadline)
                                        .foregroundColor(.blue)
                                }
                            }
                            .buttonStyle(BorderlessButtonStyle())
                            .padding(.top, 5)
                        }
                    }
                    .padding(.vertical, 5)
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(navigationTitle)
    }
    
    private var navigationTitle: String {
        switch mode {
        case .practice:
            return "Practice Poses"
        case .learn:
            return "Learn Poses"
        case .favorites:
            return "Favorites"
        }
    }
}
