//
//  PoseLearnView.swift
//  FinalProject
//
//  Created by William Epperly on 12/14/24.
//

import Foundation
import SwiftUI

struct PoseLearnView: View {
    let availablePoses: [YogaPose]

    var body: some View {
        List(availablePoses) { pose in
            NavigationLink(
                destination: LearnPosesView(selectedPose: pose)
            ) {
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
                }
                .padding(.vertical, 5)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Select Pose")
    }
}
