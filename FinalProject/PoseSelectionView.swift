//
//  PoseSelectionView.swift
//  FinalProject
//
//  Created by William Epperly on 12/14/24.
//

import Foundation
import SwiftUI

struct PoseSelectionView: View {
    @Binding var availablePoses: [YogaPose]
    
    private let poseImages: [String: String] = [
        "downdog": "downdog-preview",
        "goddess": "goddess-preview",
        "plank": "plank-preview",
        "tree": "tree-preview",
        "warrior2": "warrior2-preview"
    ]

    var body: some View {
        List {
            ForEach(availablePoses.indices, id: \.self) { index in
                let pose = availablePoses[index]
                NavigationLink(destination: LivePoseFeedbackView(selectedPose: pose)) {
                    VStack(alignment: .leading, spacing: 12) {
                        if let imageName = poseImages[pose.name],
                           let uiImage = UIImage(named: imageName) ?? UIImage(contentsOfFile: Bundle.main.path(forResource: imageName, ofType: "jpg") ?? "") {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 150)
                                .clipped()
                                .cornerRadius(8)
                        } else {
                            // Fallback if image loading fails
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

                            // Favorite button
                            Button(action: {
                                availablePoses[index].isFavorite.toggle()
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
        .navigationTitle("Select Pose")
    }
}
