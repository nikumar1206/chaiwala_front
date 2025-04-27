//
//  RecipeViewer.swift
//  chaiwala
//
//  Created by Nikhil Kumar on 4/26/25.
//
import SwiftUI
import UIKit

struct ShareSheet: UIViewControllerRepresentable {
    var items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

struct ShareButton: View {
    let recipe: RecipeWSteps
    @State private var isSharePresented: Bool = false
    
    var body: some View {
        Button(action: {
            isSharePresented = true
        }) {
            HStack {
                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 16))
                Text("Share Recipe")
                    .font(.system(size: 16, weight: .medium))
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [cinnamonBrown, deepAmber]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .sheet(isPresented: $isSharePresented) {
            // Create shareable content
            let shareText = """
            Check out this amazing recipe!
            
            \(recipe.title)
            
            Prep Time: \(recipe.prepTimeMinutes) minutes
            Serves: \(recipe.servings)
            
            \(recipe.description)
            """
            
            ShareSheet(items: [shareText])
        }
    }
}


struct RecipeViewer: View {
    let recipe: RecipeWSteps
    @State private var isFavorite: Bool = false
    @Environment(\.dismiss) var dismiss
    @State private var activeTab: Int = 0
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Header Image with Overlay
                ZStack(alignment: .topLeading) {
                    CustomAsyncImage(recipe.assetId) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 300)
                            .clipped()
                    } placeholder: {
                        Color(hex: "E8DFD5")
                            .frame(height: 300)
                            .overlay(
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: cinnamonBrown))
                            )
                    }
                    
                    // Navigation and favorite buttons - modern style
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "arrow.left")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(deepAmber)
                        }
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())
                        
                        Spacer()
                        
                        Button(action: {
                            print("touch button")
                            isFavorite.toggle()
                            // todo: add favoriting logic
                        }) {
                            Image(systemName: isFavorite ? "heart.fill" : "heart")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(isFavorite ? terracotta : .white)
                        }
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    
                    // Recipe title and time info
                    VStack(alignment: .leading, spacing: 12) {
                        Text(recipe.title)
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                            .shadow(color: Color.black.opacity(0.5), radius: 4, x: 0, y: 2)
                        
                        HStack(spacing: 16) {
                            HStack(spacing: 6) {
                                Image(systemName: "clock.fill")
                                    .foregroundColor(.white)
                                Text("\(recipe.prepTimeMinutes) mins")
                                    .foregroundColor(.white)
                            }
                            .font(.system(size: 15, weight: .medium))
                            
                            HStack(spacing: 6) {
                                Image(systemName: "person.2.fill")
                                    .foregroundColor(.white)
                                Text("\(recipe.servings) servings")
                                    .foregroundColor(.white)
                            }
                            .font(.system(size: 15, weight: .medium))
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 24)
                    .frame(maxWidth: .infinity, maxHeight: 300, alignment: .bottomLeading)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [.clear, .black.opacity(0.7)]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                }
                
                // Tab selection
                HStack(spacing: 0) {
                    TabButton(title: "Overview", isSelected: activeTab == 0) {
                        activeTab = 0
                    }
                    
                    TabButton(title: "Instructions", isSelected: activeTab == 1) {
                        activeTab = 1
                    }
                }
                .padding(.top, 16)
                
                // Content divider
                Rectangle()
                    .fill(activeTab == 0 ?
                          LinearGradient(gradient: Gradient(colors: [softChai, cinnamonBrown]), startPoint: .leading, endPoint: .trailing) :
                          LinearGradient(gradient: Gradient(colors: [cinnamonBrown, softChai]), startPoint: .trailing, endPoint: .leading))
                    .frame(height: 3)
                
                // Tab content
                VStack(alignment: .leading, spacing: 28) {
                    if activeTab == 0 {
                        // Overview tab
                        VStack(alignment: .leading, spacing: 28) {
                            // Description
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Description")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(cinnamonBrown)
                                
                                Text(recipe.description)
                                    .font(.system(size: 16))
                                    .foregroundColor(Color(hex: "333333"))
                                    .fixedSize(horizontal: false, vertical: true)
                                    .lineSpacing(4)
                            }
                            
                            // Info section
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Information")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(cinnamonBrown)
                                
                                VStack(spacing: 16) {
                                    HStack(spacing: 16) {
                                        InfoCard(
                                            image: "clock.fill",
                                            title: "Prep Time",
                                            value: "\(recipe.prepTimeMinutes) minutes",
                                            iconColor: cinnamonBrown
                                        )
                                        
                                        InfoCard(
                                            image: "person.2.fill",
                                            title: "Servings",
                                            value: "\(recipe.servings)",
                                            iconColor: softChai
                                        )
                                    }
                                    
                                    HStack(spacing: 16) {
                                        InfoCard(
                                            image: "calendar",
                                            title: "Created",
                                            value: formattedDate(recipe.createdAtDateTime()),
                                            iconColor: forestGreen
                                        )
                                        
                                        InfoCard(
                                            image: "arrow.triangle.2.circlepath",
                                            title: "Updated",
                                            value: formattedDate(recipe.updatedAtDateTime()),
                                            iconColor: terracotta
                                        )
                                    }
                                }
                            }
                            
                            // Share button
                            Button(action: {
                                // Add share functionality
                            }) {
                                HStack {
                                    Image(systemName: "square.and.arrow.up")
                                        .font(.system(size: 16))
                                    Text("Share Recipe")
                                        .font(.system(size: 16, weight: .medium))
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [cinnamonBrown, deepAmber]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            }
                            .padding(.top, 8)
                        }
                    } else {
                        // Instructions tab
                        VStack(alignment: .leading, spacing: 28) {
                            Text("Step-by-Step Instructions")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(cinnamonBrown)
                            
                            StepByStepInstructions(steps: recipe.steps)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 28)
                .padding(.bottom, 30)
            }
        }
        .edgesIgnoringSafeArea(.top)
        .background(backgroundCream)
        .navigationBarHidden(true)
    }
    
    // Helper function to format dates
    private func formattedDate(_ date: Date?) -> String {
        guard let date = date else { return "Unknown" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

// MARK: - Supporting Views

struct TabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(isSelected ? cinnamonBrown : .gray)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                
                Rectangle()
                    .frame(height: 3)
                    .foregroundColor(isSelected ? cinnamonBrown : warmCream)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct InfoCard: View {
    let image: String
    let title: String
    let value: String
    let iconColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: image)
                    .foregroundColor(iconColor)
                    .font(.system(size: 16))
                
                Text(title)
                    .font(.system(size: 14))
                    .foregroundColor(Color.gray.opacity(0.8))
            }
            
            Text(value)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Color(hex: "333333"))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(warmCream)
        .cornerRadius(10)
    }
}

// Updated to use PreparationStepSerializable instead of string parsing
struct StepByStepInstructions: View {
    let steps: [PreparationStepSerializable]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 26) {
            ForEach(steps.sorted(by: { $0.stepNumber < $1.stepNumber })) { step in
                StepView(step: step)
            }
        }
    }
}

struct StepView: View {
    let step: PreparationStepSerializable
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top, spacing: 16) {
                // Step number with gradient background
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [deepAmber, cinnamonBrown]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 34, height: 34)
                    
                    Text("\(step.stepNumber)")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                }
                
                Text(step.description)
                    .font(.system(size: 16))
                    .foregroundColor(Color(hex: "333333"))
                    .fixedSize(horizontal: false, vertical: true)
                    .lineSpacing(4)
            }
            
            // Step image if available
            if let assetId = step.assetId {
                CustomAsyncImage(assetId) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(height: 180)
                        .clipped()
                        .cornerRadius(12)
                } placeholder: {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(hex: "E8DFD5"))
                        .frame(height: 180)
                        .overlay(
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: cinnamonBrown))
                        )
                }
                .padding(.leading, 50) // Align with the step text
            }
        }
    }
}

#Preview {
    let r = RecipeWSteps(
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
    )
    RecipeViewer(recipe: r)
}
