//
//  Landing.swift
//  chaiwala
//
//  Created by Nikhil Kumar on 4/6/25.
//

import SwiftUI

struct LandingView: View {
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color("ChaiBrown"), Color("CreamWhite")]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(spacing: 32) {
                    Spacer()

                    VStack(spacing: 8) {
                        Image(systemName: "cup.and.saucer.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.white)
                        
                        Text("Chaiwala")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }

                    Text("Discover Indian tea recipes, save your favorites, and brew the perfect chai.")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white.opacity(0.85))
                        .padding(.horizontal, 32)

                    VStack(spacing: 16) {
                        NavigationLink(destination: LoginView()) {
                            Text("Login")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white)
                                .foregroundColor(.black)
                                .cornerRadius(12)
                        }

                        NavigationLink(destination: RegisterView()) {
                            Text("Register")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.black.opacity(0.8))
                                .foregroundColor(.white)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.white.opacity(0.6), lineWidth: 1)
                                )
                        }
                    }
                    .padding(.horizontal, 32)

                    Spacer()
                }
            }
        }
    }
}


struct LandingPageView: View {
    
    @StateObject var model = RecipesModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(model.recipes) { recipe in
                        RecipeCardView(recipe: recipe)
                            .padding(.horizontal)
                    }
                }
                .padding(.top)
            }
            .navigationTitle("Chaiwala")
        }.task {
            await model.getRecipes()
        }
    }
}


@MainActor
class RecipesModel: ObservableObject {
    @Published var recipes: [Recipe] = []

    init() {}

    func getRecipes() async {
        let result = await RecipeService.shared.getRecipes()
        switch result {
        case .success(let recipes):
            // Handle successful login (e.g., navigate to the next screen)
            self.recipes = recipes

        case .failure(let error):
            print("could not get recipes \(error.localizedDescription)")
        }
    }
}

#Preview {
    LandingPageView()
}
