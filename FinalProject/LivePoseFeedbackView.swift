//
//  LivePoseFeedbackView.swift
//  FinalProject
//
//  Created by Ashley Cardot on 12/13/24.
//


import SwiftUI
import AVFoundation

struct LivePoseFeedbackView: View {
    @StateObject private var viewModel = LivePoseFeedbackViewModel()
    @State private var showingVideoTutorial = false
    let selectedPose: YogaPose
    
    var body: some View {
        VStack {
            Text(selectedPose.name.capitalized)
                            .font(.system(size: 30, weight: .bold))
                            .padding()
            
            ZStack {
                CameraPreview(captureSession: viewModel.captureSession)
                    .aspectRatio(3/4, contentMode: .fit)
                    .cornerRadius(10)
                    .overlay(
                        VStack {
                            HStack {
                                Spacer()
                                Button(action: {
                                    viewModel.toggleCamera()
                                }) {
                                    Image(systemName: "camera.rotate")
                                        .foregroundColor(.white)
                                        .font(.system(size: 24))
                                        .padding()
                                        .background(Color.black.opacity(0.7))
                                        .clipShape(Circle())
                                }
                                .padding()
                            }
                            
                            Spacer()
                            
                            if viewModel.feedbackMessage.contains("Great!") {
                                Image(systemName: "hand.thumbsup.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.green)
                                    .frame(width: 100, height: 100)
                                    .padding()
                            } else if viewModel.feedbackMessage.contains("Adjust") {
                                Image(systemName: "hand.thumbsdown.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.red)
                                    .frame(width: 100, height: 100)
                                    .padding()
                            }
                            
                            Text(viewModel.feedbackMessage)
                                .foregroundColor(.white)
                                .font(.headline)
                                .padding()
                                .background(Color.black.opacity(0.7))
                                .cornerRadius(10)
                        }
                    )
                
                if !viewModel.isCameraAuthorized {
                    Text("Camera access required. Please enable in settings.")
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(10)
                }
            }
            .frame(maxHeight: .infinity)
            .padding()
            
            VStack {
                ForEach(selectedPose.instructions, id: \.self) { instruction in
                    Text(instruction)
                        .font(.callout)
                        .padding(.horizontal)
                }
            }
            .padding()
            
            Spacer()
        }
        .navigationTitle("Live Feedback")
        .alert("Need Help?", isPresented: $viewModel.showVideoPrompt) {
            Button("Watch Tutorial") {
                viewModel.stopCamera() // Stop the camera before showing tutorial
                showingVideoTutorial = true
                viewModel.showVideoPrompt = false
            }
            Button("Keep Practicing", role: .cancel) {
                viewModel.showVideoPrompt = false
            }
        } message: {
            Text("Would you like to watch a video tutorial on how to do this pose correctly?")
        }
        .sheet(isPresented: $showingVideoTutorial) {
            NavigationStack {
                LearnPosesView(selectedPose: selectedPose)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Done") {
                                showingVideoTutorial = false
                                viewModel.setupCamera() // Restart camera when returning
                            }
                        }
                    }
            }
        }
        .onAppear {
            viewModel.selectedPose = selectedPose.name
            viewModel.checkCameraAuthorization()
        }
        .onDisappear {
            viewModel.stopCamera()
        }
    }
}
