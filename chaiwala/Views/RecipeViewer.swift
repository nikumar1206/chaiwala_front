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
                    .font(.custom("Winky Sans", size: 16))
                Text("Share Recipe")
                    .font(.custom("Winky Sans", size: 16))
                    .fontWeight(.medium)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(ChaiColors.orangeAccent) // Updated background
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
                // Header Image (No Overlay)
                ZStack(alignment: .topLeading) {
                    CustomAsyncImage(recipe.assetId) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 300)
                            .clipped()
                    } placeholder: {
                        ChaiColors.warmCream // Placeholder color
                            .frame(height: 300)
                            .overlay(
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: ChaiColors.cinnamonBrown))
                            )
                    }
                    
                    // Navigation and favorite buttons
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "arrow.left")
                                .font(.custom("Winky Sans", size: 18))
                                .fontWeight(.medium)
                                .foregroundColor(ChaiColors.cinnamonBrown) // Updated color
                        }
                        .frame(width: 44, height: 44)
                        .background(Color.black.opacity(0.1)) // Subtle background for visibility
                        .clipShape(Circle())
                        .contentShape(Rectangle())
                        
                        Spacer()
                        
                        Button(action: {
                            isFavorite.toggle()
                            // todo: add favoriting logic
                        }) {
                            Image(systemName: isFavorite ? "heart.fill" : "heart")
                                .font(.custom("Winky Sans", size: 18))
                                .fontWeight(.medium)
                                .foregroundColor(isFavorite ? ChaiColors.orangeAccent : ChaiColors.warmCream) // Updated colors
                        }
                        .frame(width: 44, height: 44)
                        .background(Color.black.opacity(0.1)) // Subtle background for visibility
                        .clipShape(Circle())
                        .contentShape(Rectangle())
                    }
                    .padding(.horizontal, 16) // Adjusted padding
                    .padding(.top, (UIApplication.shared.connectedScenes
                        .compactMap { ($0 as? UIWindowScene)?.keyWindow }
                        .first?.safeAreaInsets.top ?? 0) + ((UIApplication.shared.connectedScenes
                        .compactMap { ($0 as? UIWindowScene)?.keyWindow }
                        .first?.safeAreaInsets.top ?? 0) > 0 ? 10 : 20)) // Modern safe area + conditional padding
                }

                // Recipe Title and Time Info (Moved Below Image)
                VStack(alignment: .leading, spacing: 8) {
                    Text(recipe.title)
                        .font(.custom("Winky Sans", size: 28)) // Slightly smaller for below-image context
                        .fontWeight(.bold)
                        .foregroundColor(ChaiColors.cinnamonBrown)
                    
                    HStack(spacing: 16) {
                        HStack(spacing: 6) {
                            Image(systemName: "clock.fill")
                            Text("\(recipe.prepTimeMinutes) mins")
                        }
                        .font(.custom("Winky Sans", size: 15))
                        .fontWeight(.medium)
                        .foregroundColor(ChaiColors.kadakGreen)
                        
                        HStack(spacing: 6) {
                            Image(systemName: "person.2.fill")
                            Text("\(recipe.servings) servings")
                        }
                        .font(.custom("Winky Sans", size: 15))
                        .fontWeight(.medium)
                        .foregroundColor(ChaiColors.kadakGreen)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16) // Added vertical padding
                
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
                .background(Color(UIColor.systemBackground)) // Match CreateRecipeV2
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color(UIColor.systemGray5)), // Match CreateRecipeV2
                    alignment: .bottom
                )
                
                // Tab content (Content Divider Removed)
                VStack(alignment: .leading, spacing: 28) {
                    if activeTab == 0 {
                        // Overview tab
                        VStack(alignment: .leading, spacing: 28) {
                            // Description
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Description")
                                    .font(.custom("Winky Sans", size: 20))
                                    .fontWeight(.semibold)
                                    .foregroundColor(ChaiColors.cinnamonBrown)
                                
                                Text(recipe.description)
                                    .font(.custom("Winky Sans", size: 16))
                                    .foregroundColor(ChaiColors.kadakGreen) // Using kadakGreen for general text
                                    .fixedSize(horizontal: false, vertical: true)
                                    .lineSpacing(4)
                            }
                            
                            // Info section
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Information")
                                    .font(.custom("Winky Sans", size: 20))
                                    .fontWeight(.semibold)
                                    .foregroundColor(ChaiColors.cinnamonBrown)
                                
                                VStack(spacing: 16) {
                                    VStack(spacing: 12) { // Reduced spacing for a cleaner look
                                        InfoDetailRow(image: "clock.fill", title: "Prep Time", value: "\(recipe.prepTimeMinutes) minutes", iconColor: ChaiColors.cinnamonBrown)
                                        InfoDetailRow(image: "person.2.fill", title: "Servings", value: "\(recipe.servings)", iconColor: ChaiColors.softChai)
                                        InfoDetailRow(image: "calendar", title: "Created", value: formattedDate(recipe.createdAtDateTime()), iconColor: ChaiColors.forestGreen)
                                        InfoDetailRow(image: "arrow.triangle.2.circlepath", title: "Updated", value: formattedDate(recipe.updatedAtDateTime()), iconColor: ChaiColors.terracotta)
                                    }
                                }
                                
                                // Share button
                                ShareButton(recipe: recipe) // Re-using the updated ShareButton
                                    .padding(.top, 8)
                            }
                        }
                    } else {
                        // Instructions tab
                        VStack(alignment: .leading, spacing: 28) {
                            Text("Step-by-Step Instructions")
                                .font(.custom("Winky Sans", size: 20))
                                .fontWeight(.semibold)
                                .foregroundColor(ChaiColors.cinnamonBrown)
                            
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
        .background(ChaiColors.malai)
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
            VStack(spacing: 8) { // Matches TabButtonV2 spacing
                Text(title)
                    .font(.custom("Winky Sans", size: 16)) // Adjusted size to match TabButtonV2 more closely if needed
                    .fontWeight(isSelected ? .semibold : .regular) // Match TabButtonV2
                    .foregroundColor(isSelected ? ChaiColors.cinnamonBrown : Color(.systemGray)) // Match TabButtonV2
                    .padding(.vertical, 12) // Match TabButtonV2
                
                if isSelected {
                    Rectangle()
                        .fill(ChaiColors.cinnamonBrown) // Match TabButtonV2 selected state
                        .frame(height: 2) // Match TabButtonV2
                } else {
                    Rectangle()
                        .fill(Color.clear) // Match TabButtonV2 unselected state
                        .frame(height: 2) // Match TabButtonV2
                }
            }
        }
        .frame(maxWidth: .infinity)
        .buttonStyle(PlainButtonStyle()) // Match TabButtonV2
    }
}

// Redesigned InfoCard to InfoDetailRow for minimalism
struct InfoDetailRow: View {
    let image: String
    let title: String
    let value: String
    let iconColor: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: image)
                .foregroundColor(iconColor)
                .font(.custom("Winky Sans", size: 16))
                .frame(width: 20, alignment: .center) // Align icons
            
            Text(title)
                .font(.custom("Winky Sans", size: 15))
                .foregroundColor(ChaiColors.cinnamonBrown)
            
            Spacer()
            
            Text(value)
                .font(.custom("Winky Sans", size: 15))
                .fontWeight(.medium)
                .foregroundColor(ChaiColors.kadakGreen)
        }
        .padding(.vertical, 4) // Minimal vertical padding
    }
}

// Updated to use PreparationStepSerializable instead of string parsing
struct StepByStepInstructions: View {
    let steps: [PreparationStepSerializable]

    var body: some View {
        VStack(alignment: .leading, spacing: 26) {
            ForEach(Array(steps.enumerated()), id: \.offset) { index, step in
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
                        .fill(ChaiColors.orangeAccent) // Solid color fill
                        .frame(width: 34, height: 34)
                    
                    Text("\(step.stepNumber)")
                        .font(.custom("Winky Sans", size: 16))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                
                Text(step.description)
                    .font(.custom("Winky Sans", size: 16))
                    .foregroundColor(ChaiColors.kadakGreen) // Using kadakGreen for general text
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
                        .fill(ChaiColors.warmCream) // Using warmCream for placeholder background
                        .frame(height: 180)
                        .overlay(
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: ChaiColors.cinnamonBrown))
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
            PreparationStepSerializable( stepNumber: 1, description: "Boil water and spices.", assetId: nil),
            PreparationStepSerializable(stepNumber: 2 , description: "Add tea leaves and milk.", assetId: nil),
            PreparationStepSerializable(stepNumber: 3 ,description: "Simmer and strain.", assetId: nil)
        ],
        type: TeaType.black.rawValue,
        assetId: "fd2de44e-6952-48be-9497-c5d3a8fef955",
        prepTimeMinutes: 5,
        servings: 2,
        isPublic: true,
        createdAt: "2021-01-01T00:00:00Z",
        updatedAt: "2021-01-01T00:00:00Z"
    )
    RecipeViewer(recipe: r)
}
