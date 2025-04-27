//
//  Recipe.swift
//  chaiwala
//
//  Created by Nikhil Kumar on 4/11/25.
//

import SwiftUI

struct RecipeCardView: View {
    let recipe: Recipe
    @State private var navigateToDetail = false
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 8) {
                CustomAsyncImage(recipe.assetId) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(height: 180)
                        .clipped()
                        .cornerRadius(16)
                } placeholder: {
                    Color("PastelPlaceholder")
                        .frame(height: 180)
                        .cornerRadius(16)
                        .overlay(
                            ProgressView()
                        )
                }
                
                Text(recipe.title)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(deepAmber)
                    .lineLimit(2)
                
                Text(recipe.description)
                    .font(.subheadline)
                    .foregroundColor(deepAmber)
                    .lineLimit(2)
                
                HStack {
                    Label("\(recipe.prepTimeMinutes) mins", systemImage: "clock")
                    Spacer()
                    Label("\(recipe.servings) servings", systemImage: "person.2.fill")
                }
                .font(.caption)
                .foregroundColor(.gray)
            }
            .padding()
            .background(Color("CardBackground"))
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
            .contentShape(Rectangle()) // Makes the entire card tappable
            .onTapGesture {
                print("did we get a tap gesture")
                navigateToDetail = true
            }
            .navigationDestination(isPresented: $navigateToDetail) {
                RecipeViewer(recipe: RecipeWSteps(
                    id: 1,
                    userId: 1,
                    title: "Masala Chai",
                    description: "A flavorful Indian spiced tea.",
                    steps:  [
                        PreparationStepSerializable(id: 1, stepNumber: 1, description: "Boil water and spices.", assetId: nil),
                        PreparationStepSerializable(id:2 ,stepNumber: 2 , description: "Add tea leaves and milk.", assetId: nil),
                        PreparationStepSerializable(id: 3, stepNumber: 3 ,description: "Simmer and strain.", assetId: nil)
                    ],
                    
                    assetId: "fd2de44e-6952-48be-9497-c5d3a8fef955",
                    prepTimeMinutes: 5,
                    servings: 2,
                    isPublic: true,
                    createdAt: "2021-01-01T00:00:00Z",
                    updatedAt: "2021-01-01T00:00:00Z"
                ))
            }
        }
    }
        
}

#Preview {
    let r = Recipe(
        id: 1,
        userId: 1,
        title: "",
        description: "Masala Chai",
        instructions: "A flavorful Indian spiced tea.",
        
//        steps:  [
//            PreparationStepSerializable(id: 1, stepNumber: 1, description: "Boil water and spices.", assetId: nil),
//            PreparationStepSerializable(id:2 ,stepNumber: 2 , description: "Add tea leaves and milk.", assetId: nil),
//            PreparationStepSerializable(id: 3, stepNumber: 3 ,description: "Simmer and strain.", assetId: nil)
//        ],
        assetId: "fd2de44e-6952-48be-9497-c5d3a8fef955",
        prepTimeMinutes: 5,
        servings: 2,
        isPublic: true,
        createdAt: "2025-04-26T13:25:42.896539",
        updatedAt: "2025-04-26T13:25:42.896539"
    )
    RecipeCardView(recipe: r)
}
