//
//  PreparationSteps.swift
//  chaiwala
//
//  Created by Nikhil Kumar on 4/21/25.
//

import SwiftUI
import PhotosUI

// Model for preparation steps
struct PreparationStep: Identifiable {
    var id = UUID()
    var stepNumber: Int
    var description: String
    var imageData: Data?
}

struct PreparationStepsView: View {
    @Binding var steps: [PreparationStep]
    @State private var newStepDescription: String = ""
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    @State private var isAddingStep = false
    
    // Colors matching the main app theme
    private let warmCream = Color(red: 0.98, green: 0.95, blue: 0.87)
    private let cinnamonBrown = Color(red: 0.6, green: 0.4, blue: 0.3)
    private let softChai = Color(red: 0.7, green: 0.5, blue: 0.3)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Preparation Steps")
                .font(.custom("Winky Sans", size: 20))
                .fontWeight(.medium)
                .foregroundColor(cinnamonBrown)
                .padding(.horizontal)
            
            if steps.isEmpty {
                Text("No steps added yet")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
            } else {
                ForEach(steps) { step in
                    stepView(step: step)
                }
            }
            
            if isAddingStep {
                addStepForm
            } else {
                addStepButton
            }
        }
    }
    
    private var addStepButton: some View {
        Button(action: {
            isAddingStep = true
        }) {
            HStack {
                Image(systemName: "plus")
                Text("Add Step")
                    .fontWeight(.medium)
            }
            .foregroundColor(softChai)
            .frame(maxWidth: .infinity)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(warmCream, lineWidth: 2)
            )
        }
        .padding(.horizontal)
    }
    
    private var addStepForm: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Step number and camera icon in the same line
            HStack {
                Text("Step \(steps.count + 1)")
                    .font(.headline)
                    .foregroundColor(cinnamonBrown)
                
                Spacer()
                
                // Photo upload button or thumbnail
                if let imageData = selectedImageData, let uiImage = UIImage(data: imageData) {
                    ZStack {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 36, height: 36)
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color.white, lineWidth: 2)
                            )
                        
                        // Close button overlay
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.white)
                            .background(Color.black.opacity(0.6))
                            .clipShape(Circle())
                            .font(.system(size: 14))
                            .padding(2)
                    }
                    .onTapGesture {
                        selectedItem = nil
                        selectedImageData = nil
                    }
                } else {
                    PhotosPicker(
                        selection: $selectedItem,
                        matching: .images,
                        photoLibrary: .shared()) {
                            Image(systemName: "camera")
                                .foregroundColor(.orange)
                                .font(.system(size: 18))
                                .frame(width: 36, height: 36)
                                .background(warmCream)
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(Color.orange.opacity(0.5), lineWidth: 1)
                                )
                        }
                        .onChange(of: selectedItem) { newItem in
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                    selectedImageData = data
                                }
                            }
                        }
                }
            }
            
            // Clean text editor without the icon
            TextEditor(text: $newStepDescription)
                .frame(height: 120)
                .padding(4)
                .background(warmCream)
                .cornerRadius(8)

            
            HStack {
                Button(action: {
                    isAddingStep = false
                    newStepDescription = ""
                    selectedImageData = nil
                    selectedItem = nil
                }) {
                    Text("Cancel")
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button(action: {
                    if !newStepDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        let newStep = PreparationStep(
                            stepNumber: steps.count + 1,
                            description: newStepDescription,
                            imageData: selectedImageData
                        )
                        steps.append(newStep)
                        newStepDescription = ""
                        selectedImageData = nil
                        selectedItem = nil
                        isAddingStep = false
                    }
                }) {
                    Text("Save Step")
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(cinnamonBrown)
                        .cornerRadius(8)
                }
                .disabled(newStepDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                .opacity(newStepDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.6 : 1)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
    }
    
    private func stepView(step: PreparationStep) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                Text("\(step.stepNumber)")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(width: 30, height: 30)
                    .background(cinnamonBrown)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(step.description)
                        .font(.body)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    if let imageData = step.imageData, let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity)
                            .frame(height: 160)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .clipped()
                    }
                }
                
                Spacer()
                
                Button(action: {
                    if let index = steps.firstIndex(where: { $0.id == step.id }) {
                        steps.remove(at: index)
                        // Renumber steps
                        for i in index..<steps.count {
                            steps[i].stepNumber = i + 1
                        }
                    }
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(warmCream)
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

#Preview {
    ScrollView {
        PreparationStepsView(steps: .constant([
            PreparationStep(stepNumber: 1, description: "Boil water to 175°F (80°C) - just before boiling point.", imageData: nil),
            PreparationStep(stepNumber: 2, description: "Place tea leaves in teapot and pour hot water over them.", imageData: nil)
        ]))
    }
}
