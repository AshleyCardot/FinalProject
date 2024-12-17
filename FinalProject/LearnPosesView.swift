import SwiftUI
import AVKit

struct LearnPosesView: View {
    let selectedPose: YogaPose
    @State private var player: AVPlayer?
    @State private var isVideoExpanded: Bool = true
    @State private var isDescriptionExpanded: Bool = true
    @State private var isFullScreen: Bool = false
    @State private var appearAnimation: Bool = false
    @Environment(\.dismiss) private var dismiss
    
    let poseDetails: [String: (text: String, video: String, image: String, level: String)] = [
        "tree": ("Tree Pose helps improve balance and stability.", "tree", "treepose", "beginner"),
        "downdog": ("Downward Dog stretches your back and strengthens your arms.", "downdog", "downdog", "beginner"),
        "plank": ("Plank Pose builds core strength and stamina.", "plank", "plank", "beginner"),
        "goddess": ("Goddess Pose strengthens your legs and opens your hips.", "goddess", "goddess", "intermediate"),
        "warrior2": ("Warrior II builds strength and stability in the legs and core.", "warrior2", "warrior2", "beginner")
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 0) {
                    if let details = poseDetails[selectedPose.name.lowercased()] {
                        // Header Section
                        ZStack(alignment: .bottom) {
                            // Background Image
                            Image("sunset")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geometry.size.width, height: geometry.size.width * 0.6)
                                .clipped()
                                .overlay(
                                    LinearGradient(
                                        gradient: Gradient(colors: [.clear, .black.opacity(0.3)]),
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                            
                            // Pose Image
                            Image(details.image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geometry.size.width * 0.4, height: geometry.size.width * 0.4)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                .shadow(radius: 10)
                                .offset(y: geometry.size.width * 0.2)
                                .opacity(appearAnimation ? 1 : 0)
                        }
                        .frame(width: geometry.size.width, height: geometry.size.width * 0.6)
                        
                        // Content Section
                        VStack(spacing: 25) {
                            // Title Section
                            VStack(spacing: 8) {
                                Text(selectedPose.name.capitalized)
                                    .font(.system(size: 32, weight: .bold, design: .rounded))
                                    .padding(.top, geometry.size.width * 0.25)
                                    .opacity(appearAnimation ? 1 : 0)
                                
                                PoseLevelBadge(level: details.level)
                                    .opacity(appearAnimation ? 1 : 0)
                            }
                            
                            // Video Section
                            VStack(spacing: 12) {
                                SectionHeader(title: "Practice Along", icon: "play.circle.fill")
                                
                                if let player = player {
                                    ZStack(alignment: .topTrailing) {
                                        VideoPlayer(player: player)
                                            .frame(height: min(geometry.size.width * 0.56, 220))
                                            .clipShape(RoundedRectangle(cornerRadius: 16))
                                        
                                        Button {
                                            isFullScreen = true
                                        } label: {
                                            Image(systemName: "arrow.up.left.and.arrow.down.right")
                                                .font(.system(size: 20, weight: .semibold))
                                                .foregroundColor(.white)
                                                .padding(8)
                                                .background(.ultraThinMaterial)
                                                .clipShape(Circle())
                                                .padding(12)
                                        }
                                    }
                                    .sheet(isPresented: $isFullScreen) {
                                        FullScreenVideoPlayer(player: player)
                                    }
                                } else {
                                    LoadingView()
                                        .frame(height: min(geometry.size.width * 0.56, 220))
                                }
                            }
                            .opacity(appearAnimation ? 1 : 0)
                            
                            // Instructions Section
                            VStack(spacing: 12) {
                                SectionHeader(title: "Instructions", icon: "list.bullet")
                                
                                VStack(alignment: .leading, spacing: 20) {
                                    Text(selectedPose.description)
                                        .font(.body)
                                        .foregroundColor(.secondary)
                                    
                                    VStack(alignment: .leading, spacing: 12) {
                                        ForEach(Array(selectedPose.instructions.enumerated()), id: \.1) { index, step in
                                            HStack(alignment: .top, spacing: 12) {
                                                Text("\(index + 1)")
                                                    .font(.system(.subheadline, design: .rounded))
                                                    .fontWeight(.bold)
                                                    .foregroundColor(.white)
                                                    .frame(width: 24, height: 24)
                                                    .background(Circle().fill(Color.blue))
                                                
                                                Text(step)
                                                    .font(.system(.body, design: .rounded))
                                                    .fixedSize(horizontal: false, vertical: true)
                                                    .multilineTextAlignment(.leading)
                                            }
                                        }
                                    }
                                }
                                .padding()
                                .background(Color(.systemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                            }
                            .opacity(appearAnimation ? 1 : 0)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 30)
                    }
                }
            }
            .background(Color(.systemGroupedBackground))
        }
        .ignoresSafeArea(.all, edges: .top)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            setupVideo()
            withAnimation {
                appearAnimation = true
            }
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

struct PoseLevelBadge: View {
    let level: String
    
    private var backgroundColor: Color {
        switch level.lowercased() {
        case "beginner": return .green
        case "intermediate": return .orange
        case "advanced": return .red
        default: return .blue
        }
    }
    
    var body: some View {
        Text(level.capitalized)
            .font(.system(.subheadline, design: .rounded))
            .fontWeight(.medium)
            .foregroundColor(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(backgroundColor.opacity(0.9))
            .clipShape(Capsule())
    }
}

struct SectionHeader: View {
    let title: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.blue)
            
            Text(title)
                .font(.system(.title3, design: .rounded))
                .fontWeight(.bold)
            
            Spacer()
        }
    }
}

struct LoadingView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray.opacity(0.1))
            
            ProgressView()
                .scaleEffect(1.5)
        }
    }
}

struct FullScreenVideoPlayer: View {
    let player: AVPlayer
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VideoPlayer(player: player)
                .edgesIgnoringSafeArea(.all)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            dismiss()
                        }
                    }
                }
        }
    }
}
