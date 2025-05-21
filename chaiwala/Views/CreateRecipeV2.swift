//
//  CreateRecipeV2.swift
//  chaiwala
//
//  Created by Nikhil Kumar on 5/4/25.
//

import SwiftUI
import PhotosUI

struct RecipeCreationViewV2: View {
    @State private var recipeTitle: String = ""
    @State private var description: String = ""
    @State private var prepTime: String = ""
    @State private var recipeType: TeaType = TeaType.black
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    @State private var preparationSteps: [PreparationStep] = []
    @State private var currentTab: Tab = .details
    
    enum Tab {
        case details, steps
    }
        var body: some View {
        VStack(spacing: 0) {
            // Modern header with visual elements
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("Brew")
                        .font(.custom("Winky Sans", size: 32))
                        .fontWeight(.bold)
                        .foregroundColor(cinnamonBrown)
                    
                    Spacer()
                    
                    Button(action: {
                        Task {
                            await uploadStepsAndCreateRecipe(recipeTitle: self.recipeTitle, description: self.description, prepTime: Int(self.prepTime) ?? 0, type: self.recipeType, selectedImageData: self.selectedImageData, preparationSteps: self.preparationSteps)
                        }
                    }) {
                        Circle()
                            .fill(orangeAccent)
                            .frame(width: 40, height: 40)
                            .overlay(
                                Image(systemName: "checkmark")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.white)
                            )
                    }
                }
                
                Text("Your own creation")
                    .font(.custom("Winky Sans", size: 16))
                    .foregroundColor(cinnamonBrown)
            }
            .padding(.horizontal)
            .padding(.top, 16)
            .padding(.bottom, 8)
            
            // Tab navigation
            HStack(spacing: 0) {
                TabButton(title: "Details", isSelected: currentTab == .details) {
                    withAnimation {
                        currentTab = .details
                    }
                }
                
                TabButton(title: "Steps", isSelected: currentTab == .steps) {
                    
                    withAnimation {
                        currentTab = .steps
                    }
                }
            }
            .background(Color(UIColor.systemBackground))
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color(UIColor.systemGray5)),
                alignment: .bottom
            )
            
            // Content based on selected tab
            ScrollView {
                if currentTab == .details {
                    detailsView
                } else {
                    stepsView
                }
            }
        }
        .background(ChaiColors.malai)
        .edgesIgnoringSafeArea(.bottom)
    }
    
    // Details tab content
    var detailsView: some View {
        VStack(spacing: 20) {
            // Recipe photo
            Spacer()
            ZStack {
                
                if let image = selectedImageData, let uiImage = UIImage(data: image) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 250)
                        .clipShape(RoundedRectangle(cornerRadius: 10
                                                   ))
                        .overlay(
                            Button(action: {
                                selectedItem = nil
                                selectedImageData = nil
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .padding(5)
                                    .background(Color.black.opacity(0.6))
                                    .clipShape(Circle())
                            }
                            .padding(8),
                            alignment: .topTrailing
                            
                        )
                } else {
                    PhotosPicker(
                        selection: $selectedItem,
                        matching: .images,
                        photoLibrary: .shared()
                    ) {
                        Rectangle()
                            .fill(ChaiColors.cardamomGreen)
                            .frame(height: 150)
                            .overlay(
                                VStack {
                                    Circle()
                                        .stroke(orangeAccent, lineWidth: 2)
                                        .frame(width: 60, height: 60)
                                        .overlay(
                                            Text("+")
                                                .font(.system(size: 20))
                                                .foregroundColor(orangeAccent)
                                        )
                                }
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
            .padding(.horizontal)
            
            // Modern form fields
            VStack(alignment: .leading, spacing: 25) {
                formFieldGroup(title: "WHAT'S THE BREW CALLED?") {
                    TextField("Recipe title", text: $recipeTitle)
                        .padding()
                        .overlay(        RoundedRectangle(cornerRadius: 15)
                            .stroke(warmCream, lineWidth: 1))
                        .cornerRadius(25)
                }
                
                formFieldGroup(title: "DESCRIBE YOUR BREW") {
                    TextEditor(text: $description)
                        .frame(height: 100)
                        .padding(8)
                        .background(warmCream)
                        .cornerRadius(15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(warmCream, lineWidth: 1)
                        )
                }
                
                HStack(spacing: 20) {
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "clock")
                                .foregroundColor(cinnamonBrown)
                            TextField("MIN", text: $prepTime)
                                .keyboardType(.numberPad)
                                .foregroundColor(cinnamonBrown)
                        }
                        .padding()
                        .frame(height: 50)
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(25)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    TeaTypeDropDown(selectedTea: self.$recipeType)
                    
                }
            }
            .padding()
        }
    }
    
    // Steps tab content
    var stepsView: some View {
        VStack(alignment: .leading, spacing: 16) {
            if preparationSteps.isEmpty {
                Text("Add steps to prepare your brew")
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center)
            } else {
                PreparationStepsView(steps: $preparationSteps)
            }
            
            Button(action: {
                let newStep = PreparationStep(id: UUID(), stepNumber: preparationSteps.count + 1, description: "", imageData: nil)
                preparationSteps.append(newStep)
            }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Add Step")
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(cinnamonBrown)
                .foregroundColor(.white)
                .cornerRadius(25)
            }
            .padding()
        }
        .padding(.vertical)
    }
    
    // Helper for form fields
    private func formFieldGroup<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(cinnamonBrown)
            
            content()
        }
    }
}

// Tab button component
struct TabButtonV2: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(title)
                    .fontWeight(isSelected ? .semibold : .regular)
                    .foregroundColor(isSelected ? Color(hex: "#8B4513") : Color(.systemGray))
                    .padding(.vertical, 12)
                
                if isSelected {
                    Rectangle()
                        .fill(Color(hex: "#8B4513"))
                        .frame(height: 2)
                } else {
                    Rectangle()
                        .fill(Color.clear)
                        .frame(height: 2)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .buttonStyle(PlainButtonStyle())
    }
}


func uploadStepsAndCreateRecipeV2(recipeTitle: String, description: String, prepTime: Int, type: TeaType, selectedImageData: Data?, preparationSteps: [PreparationStep]) async {
    var assetId = ""

    // Upload recipe image if available
    if let imageData = selectedImageData {
        let uploadResult = await APIClient.shared.uploadFile(
            path: "/files",
            fileData: imageData
        )

        switch uploadResult {
        case .success(let fileResponse):
            assetId = fileResponse.FileId
        case .failure(let error):
            print("Failed to upload recipe image:", error)
            return
        }
    }

    // Upload each step image (if any) and build DTO list
    var stepDTOs: [PreparationStepSerializable] = []
    
    for step in preparationSteps {
        var fileId: String? = nil

        if let data = step.imageData {
            let uploadResult = await APIClient.shared.uploadFile(path: "/files", fileData: data)
            switch uploadResult {
            case .success(let fileResponse):
                fileId = fileResponse.FileId
            case .failure(let error):
                print("Failed to upload image for step \(step.stepNumber):", error)
                return
            }
        }

        stepDTOs.append(
            PreparationStepSerializable(
                stepNumber: step.stepNumber,
                description: step.description,
                assetId: fileId
            )
        )
    }

    // Construct the RecipeDraft
    let recipe = RecipeDraft(
        id: nil,
        title: recipeTitle,
        description: description,
        steps: stepDTOs,
        teaType: Int(type.rawValue),
        assetId: assetId,
        prepTimeMinutes: prepTime,
        servings: 1,
        isPublic: true
    )

    // Fire create API
    let result = await RecipeService.shared.createRecipe(r: recipe)

    switch result {
    case .success:
        print("Recipe created successfully")
        // Show toast or navigate
    case .failure(let error):
        print("Failed to create recipe:", error)
        // Show error alert
    }
}

#Preview {
    RecipeCreationViewV2()
}
