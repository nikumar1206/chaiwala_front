//
//  CreateRecipe.swift
//  chaiwala
//
//  Created by Nikhil Kumar on 4/12/25.
//

import SwiftUI
import PhotosUI

struct RecipeCreationView: View {
    @State private var recipeTitle: String = ""
    @State private var description: String = ""
    @State private var prepTime: String = ""
    @State private var recipeType: String = ""
    @State private var ingredients: String = ""
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    @State private var preparationSteps: [PreparationStep] = []
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    
                    Text("Create New Recipe")
                        .font(.custom("Winky Sans", size: 32))
                        .fontWeight(.semibold)
                        .foregroundColor(cinnamonBrown)
                    
                    Spacer()
                    
                    Button(action: {
                        Task {
                            var assetId = ""
                            
                            if let imageData = selectedImageData {
                                let uploadResult = await APIClient.shared.uploadFile(
                                    path: "/files",
                                    fileData: imageData,
                                )

                                switch uploadResult {
                                case .success(let fileResponse):
                                    assetId = fileResponse.FileId //
                                case .failure(let error):
                                    print("Failed to upload recipe image:", error)
                                    // Optionally show a user alert here
                                    return
                                }
                            }
                            
                            // Now create the Recipe
                            let r = RecipeDraft(
                                id: nil,
                                title: self.recipeTitle,
                                description: self.description,
                                steps: [], // you can wire this later
                                assetId: assetId,
                                prepTimeMinutes: Int(self.prepTime) ?? 0,
                                servings: 1,
                                isPublic: true
                            )
                            
                            let res = await RecipeService.shared.createRecipe(r: r)
                            
                            switch res {
                            case .success:
                                print("Recipe created successfully")
                                // Maybe navigate back or show success?
                            case .failure(let error):
                                print("Failed to create recipe:", error)
                                // Maybe show an error
                            }
                        }
                    }) {
                        Text("Save")
                            .fontWeight(.medium)
                            .foregroundColor(cinnamonBrown)
                            .padding(.horizontal, 8)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 8)
                
                
                // Recipe photo
                Button(action: {
                    showingImagePicker = true
                }) {
                    if let image = selectedImageData {
                        
                        ZStack(alignment: .topTrailing) {
                            if let uiImage = UIImage(data: image) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 200)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .clipped()
                            }
                            
                            Button(action: {
                                selectedItem = nil
                                showingImagePicker = false
                                selectedImageData = nil
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.white)
                                    .background(Color.black.opacity(0.6))
                                    .clipShape(Circle())
                            }
                            .padding(8)
                        }
                    } else {
                        ZStack {
                            PhotosPicker(
                                selection: $selectedItem,
                                matching: .images,
                                photoLibrary: .shared()) {
                                    ZStack {
                                        
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(warmCream)
                                            .frame(height: 200)
                                        
                                        VStack {
                                            Image(systemName: "plus")
                                                .font(.title)
                                                .foregroundColor(.orange)
                                            
                                            Text("Add Recipe Photo")
                                                .font(.custom("Winky Sans", size: 20))
                                                .foregroundColor(.secondary)
                                                .padding(.top, 4)
                                        }
                                    }
                                    
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
                }
                .padding(.horizontal)
                
                // Recipe Title
                VStack(alignment: .leading, spacing: 8) {
                    Text("Recipe Title")
                        .font(.custom("Winky Sans", size: 18))
                        .fontWeight(.medium)
                    
                    TextField("", text: $recipeTitle)
                        .padding()
                        .background(warmCream)
                        .cornerRadius(8)
                }
                .padding(.horizontal)
                
                // Description
                VStack(alignment: .leading, spacing: 8) {
                    Text("Description")
                        .fontWeight(.medium)
                    
                    TextEditor(text: $description)
                        .frame(height: 100)
                        .padding(4)
                        .background(warmCream)
                        .cornerRadius(8)
                }
                .padding(.horizontal)
                
                // Prep Time and Type
                HStack(spacing: 15) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Preparation Time")
                            .fontWeight(.medium)
                        
                        
                        TextField("minutes", text: $prepTime)
                            .padding()
                            .background(warmCream)
                            .cornerRadius(8)
                            .keyboardType(.numberPad)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Type")
                            .fontWeight(.medium)
                        
                        TextField("", text: $recipeType)
                            .padding()
                            .background(warmCream)
                            .cornerRadius(8)
                    }
                }
                .padding(.horizontal)
                
                // Ingredients
                VStack(alignment: .leading, spacing: 8) {
                    Text("Ingredients")
                        .fontWeight(.medium)
                    
                    TextEditor(text: $ingredients)
                        .frame(height: 100)
                        .padding(4)
                        .background(warmCream)
                        .cornerRadius(8)
                }
                .padding(.horizontal)
                
                ScrollView {
                    PreparationStepsView(steps: $preparationSteps)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
    }
}

#Preview {
    RecipeCreationView()
}
