import SwiftUI
import AVKit

struct LearnPosesView: View {
    let selectedPose: YogaPose
    @State private var player: AVPlayer?
    @State private var isVideoExpanded: Bool = false
    @State private var isDescriptionExpanded: Bool = false
    @State private var isFullScreen: Bool = false
    @Environment(\.dismiss) private var dismiss
    
    // Dictionary for pose details
    let poseDetails: [String: (text: String, video: String, image: String, level: String)] = [
        "tree": ("Tree Pose helps improve balance and stability.", "tree", "tree", "beginner"),
        "downdog": ("Downward Dog stretches your back and strengthens your arms.", "downdog", "downdog", "beginner"),
        "plank": ("Plank Pose builds core strength and stamina.", "plank", "plank", "beginner"),
        "goddess": ("Goddess Pose strengthens your legs and opens your hips.", "goddess", "goddess", "intermediate"),
        "warrior2": ("Warrior II builds strength and stability in the legs and core.", "warrior2", "warrior2", "beginner")
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                if let details = poseDetails[selectedPose.name.lowercased()] {
                    VStack(alignment: .center, spacing: 0) {
                        // Full-width header image
                        Image("sunset")
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity, maxHeight: 250)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .clipped()
                        
                        // Circular image overlapping and centered
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 220, height: 220)
                                .shadow(radius: 10)
                            
                            Image(details.image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 200, height: 200)
                                .clipShape(Circle())
                                .overlay {
                                    Circle().stroke(Color.white, lineWidth: 4)
                                }
                        }
                        .offset(y: -110)
                        .padding(.bottom, -110)
                    }
                    
                    // Pose name and level
                    VStack(alignment: .leading, spacing: 8) {
                        Text(selectedPose.name.capitalized)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Text(details.level.capitalized)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 16)
                    .multilineTextAlignment(.center)
                    
                    // Expandable Video Section with Full Screen Support
                    DisclosureGroup("Video", isExpanded: $isVideoExpanded) {
                        if let player = player {
                            ZStack(alignment: .topTrailing) {
                                VideoPlayer(player: player)
                                    .frame(height: 220)
                                    .cornerRadius(12)
                                
                                Button {
                                    isFullScreen = true
                                } label: {
                                    Image(systemName: "arrow.up.left.and.arrow.down.right")
                                        .font(.system(size: 20))
                                        .foregroundColor(.white)
                                        .padding(8)
                                        .background(.ultraThinMaterial)
                                        .cornerRadius(8)
                                        .padding(8)
                                }
                            }
                            .sheet(isPresented: $isFullScreen) {
                                FullScreenVideoPlayer(player: player)
                            }
                        } else {
                            Text("Loading video...")
                                .frame(height: 220)
                                .frame(maxWidth: .infinity)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(12)
                        }
                    }
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(10)
                    .padding(.vertical, 8)
                    
                    // Rest of the view remains the same...
                    DisclosureGroup("Description", isExpanded: $isDescriptionExpanded) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Description:")
                                .font(.headline)
                            Text(selectedPose.description)
                                .font(.body)
                            
                            Text("Instructions:")
                                .font(.headline)
                            ForEach(selectedPose.instructions, id: \.self) { step in
                                Text("• \(step)")
                                    .font(.body)
                            }
                        }
                        .padding(.top, 10)
                    }
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(10)
                    .padding(.vertical, 8)
                }
            }
            .padding(.horizontal)
        }
        .navigationTitle("Learn")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            setupVideo()
        }
        .onDisappear {
            player?.pause()
            player = nil
        }
    }
    
    private func setupVideo() {
        guard let details = poseDetails[selectedPose.name.lowercased()],
              let url = Bundle.main.url(forResource: details.video, withExtension: "mp4") else {
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set audio session category: \(error)")
        }
        
        let newPlayer = AVPlayer(url: url)
        newPlayer.seek(to: .zero)
        self.player = newPlayer
    }
}

// New FullScreenVideoPlayer view
struct FullScreenVideoPlayer: View {
    let player: AVPlayer
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VideoPlayer(player: player)
            .edgesIgnoringSafeArea(.all)
            .navigationBarItems(trailing: Button("Done") {
                dismiss()
            })
    }
}
