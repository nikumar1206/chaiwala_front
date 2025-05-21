import SwiftUI

struct HomePageView: View {
    // MARK: - State
    @State private var searchText: String = ""
    @State private var recipes: [Recipe] = []
    @State private var isLoading = false
    @State private var errorMessage: String? = nil
    @State private var showAllTeaTypes = false

    let categories: [Category] = [
        Category(name: "Black Tea", systemImage: "cup.and.saucer"),
        Category(name: "Green Tea", systemImage: "leaf"),
        Category(name: "Herbal Tea", systemImage: "flame"),
        Category(name: "Oolong Tea", systemImage: "drop")
    ]
    
    let categoryColumns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    var displayedTeaTypes: [TeaType] {
        if showAllTeaTypes {
            return TeaType.allCases
        } else {
            return Array(TeaType.allCases.prefix(6))
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header
                    VStack(spacing: 4) {
                        Text("chaiwala")
                            .font(.system(size: 40, weight: .bold, design: .rounded))
                            .foregroundColor(ChaiColors.cinnamonBrown)
                        Text("Steep your senses.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top)
                    
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search", text: $searchText)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                    }
                    .padding(12)
                    .background(ChaiColors.backgroundCream)
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(ChaiColors.kadakGreen, lineWidth: 1))
                    .padding(.horizontal)
                    
                    // Featured Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Featured")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.horizontal)
                            .foregroundColor(ChaiColors.kadakGreen)
                        
                        if isLoading {
                            ProgressView("Loading Recipes...")
                                .frame(height: 200)
                                .frame(maxWidth: .infinity)
                                .background(Color.white.opacity(0.3))
                                .cornerRadius(15)
                                .padding(.horizontal)
                        } else if let errorMessage {
                            Text("Error: \(errorMessage)")
                                .foregroundColor(.red)
                                .padding()
                                .frame(height: 200)
                                .frame(maxWidth: .infinity)
                                .background(Color.white.opacity(0.3))
                                .cornerRadius(15)
                                .padding(.horizontal)
                        } else if recipes.isEmpty {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.teal.opacity(0.2))
                                .frame(height: 200)
                                .overlay(Text("No featured recipes yet").foregroundColor(.gray))
                                .padding(.horizontal)
                        } else {
                            FeaturedCarouselView(recipes: recipes)
                                .frame(height: 200)
                                .padding(.horizontal)
                        }
                    }
                    
                    // Categories
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Tea Types")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.horizontal)
                            .foregroundColor(ChaiColors.kadakGreen)

                        LazyVGrid(columns: categoryColumns, spacing: 16) {
                            ForEach(displayedTeaTypes, id: \.rawValue) { teaType in
                                TeaTypeItemView(teaType: teaType)
                            }
                        }
                        .padding(.horizontal)

                        if !showAllTeaTypes && TeaType.allCases.count > 6 {
                            Button(action: {
                                withAnimation {
                                    showAllTeaTypes = true
                                }
                            }) {
                                Text("More")
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: 100)
                            
                                    .padding()
                                    .background(ChaiColors.cardamomGreen.opacity(0.8))
                                    .foregroundColor(.white)
                                    .cornerRadius(12)
//                                    .padding(.horizontal)
                            }
                            .frame(maxWidth: .infinity, alignment: .trailing)
                                .padding(.horizontal)
                        }
                        if showAllTeaTypes {
                            Button(action: {
                                withAnimation {
                                    showAllTeaTypes = false
                                }
                            }) {
                                Text("Show Less")
                                    .fontWeight(.semibold)
                                    .frame(width: 100)
                                    .padding()
                                    .background(Color.gray.opacity(0.3))
                                    .foregroundColor(.primary)
                                    .cornerRadius(12)
                                    .padding(.horizontal)
                            }.frame(maxWidth: .infinity, alignment: .trailing)
                                .padding(.horizontal)
                        }
                    }
                }
                .padding(.bottom, 40)
            }
            .background(ChaiColors.backgroundCream.ignoresSafeArea())
            .navigationTitle("Home")
            .navigationBarHidden(true)
            .task {
                await loadRecipes()
            }
        }
    }
    
    // MARK: - Async recipe fetching
    func loadRecipes() async {
        isLoading = true
        errorMessage = nil
        let res = await RecipeService.shared.getRecipes()
        
        switch res {
        case .success(let fetchedRecipes):
            recipes = fetchedRecipes
        case .failure(let error):
            recipes = []
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}

// MARK: - Carousel View

struct FeaturedCarouselView: View {
    let recipes: [Recipe]

    var body: some View {
        TabView {
            ForEach(recipes) { recipe in
                RecipeCardView(recipe: recipe)
//                FeaturedRecipeCard(recipe: recipe)
//                    .padding(.vertical, 10)
//                    .padding(.horizontal, 5)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
    }
}

// MARK: - Featured Recipe Card
struct TeaTypeItemView: View {
    let teaType: TeaType

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: teaType.systemImage)
                .foregroundColor(.white)
                .padding(10)
                .background(ChaiColors.kashmiriPink)
                .clipShape(Circle())

            Text(teaType.description)
                .fontWeight(.medium)
                .foregroundColor(.primary)

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.15), radius: 3, x: 0, y: 2)
    }
}

struct FeaturedRecipeCard: View {
    let recipe: Recipe

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            // Assuming your Recipe has a valid image URL or local image name
            // You can replace CustomAsyncImage with AsyncImage or your image loader
            CustomAsyncImage(recipe.assetId) { image in
                image
                    .resizable()
                    .aspectRatio(4/3, contentMode: .fill)
                    .frame(width: 400, height: 200)
                    .clipped()
                    .cornerRadius(15)
                    .shadow(radius: 4)
            } placeholder: {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color(hex: "E8DFD5"))
                    .frame(width: 280, height: 180)
                    .overlay(ProgressView().progressViewStyle(CircularProgressViewStyle(tint: ChaiColors.cinnamonBrown)))
            }

            VStack(alignment: .trailing, spacing: 4) {
                Text(recipe.title)
                    .font(.headline)
                    .foregroundColor(.white)
                    .shadow(radius: 2)
                Text("by \(recipe.userId)")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.9))
            }
            .padding(8)
            .background(Color.black.opacity(0.4))
            .cornerRadius(10)
            .padding(10)
        }
    }
}

// MARK: - Category & CategoryItemView

struct Category: Identifiable {
    var id: String { name }
    var name: String
    var systemImage: String
}

struct CategoryItemView: View {
    let category: Category

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: category.systemImage)
                .foregroundColor(.white)
                .padding(10)
                .background(ChaiColors.cinnamonBrown)
                .clipShape(Circle())

            Text(category.name)
                .fontWeight(.medium)
                .foregroundColor(.primary)

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.15), radius: 3, x: 0, y: 2)
    }
}




#Preview {
    HomePageView()
}
