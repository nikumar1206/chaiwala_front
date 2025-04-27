////
////  Home.swift
////  chaiwala
////
////  Created by Nikhil Kumar on 4/6/25.
////
//
import SwiftUI
//
// Placeholder for HomePageView
struct HomePageView: View {
    var body: some View {
        Text("Welcome to Chaiwala!")
            .font(.largeTitle)
    }
}

//// The main Landing Page View
//struct HomePageView: View {
//    // State variable to hold the search text
//    @State private var searchText: String = ""
//
//    // Dummy data for placeholders - replace with actual data fetching
//    let featuredItems: [Recipe] = [Recipe(name: "Featured Recipe 1")] // Example
//    let categories: [Category] = [
//        Category(name: "Black Tea"),
//        Category(name: "Green Tea"),
//        Category(name: "Herbal Tea"),
//        Category(name: "Oolong Tea")
//    ]
//
//    // Define grid layout for categories
//    let categoryColumns: [GridItem] = [
//        GridItem(.flexible(), spacing: 16), // Column 1
//        GridItem(.flexible(), spacing: 16)  // Column 2
//    ]
//
//    var body: some View {
//        ScrollView {
//            VStack(alignment: .leading, spacing: 20) {
//
//                VStack {
//                    Text("Chaiwala")
//                        .font(.system(size: 40, weight: .bold))
//                        .foregroundColor(Color(UIColor.systemBrown))
//
//                    Text("Discover Delicious Tea Recipes")
//                        .font(.headline)
//                        .foregroundColor(.gray)
//                }
//                .frame(maxWidth: .infinity)
//                .padding(.bottom, 10)
//
//                HStack {
//                    Image(systemName: "magnifyingglass")
//                        .foregroundColor(.gray)
//                    TextField("Search", text: $searchText)
//                }
//                .padding(12)
//                .background(Color.yellow.opacity(0.7))
//                .clipShape(Capsule())
//                .overlay(
//                    Capsule().stroke(Color.orange, lineWidth: 2)
//                )
//                .padding(.horizontal)
//
//                VStack(alignment: .leading) {
//                    Text("Featured")
//                        .font(.title2)
//                        .fontWeight(.semibold)
//                        .padding(.horizontal)
//
//
//                    RoundedRectangle(cornerRadius: 15)
//                        .fill(Color.teal.opacity(0.8))
//                        .frame(height: 200)
//                        .overlay(
//                            Path { path in
//                                path.move(to: CGPoint(x: 0, y: 0))
//                                path.addLine(to: CGPoint(x: 300, y: 200))
//                                path.move(to: CGPoint(x: 300, y: 0))
//                                path.addLine(to: CGPoint(x: 0, y: 200))
//                            }
//                            .stroke(Color.white.opacity(0.5), lineWidth: 1)
//                        )
//                        .padding(.horizontal)
//                        .shadow(radius: 3, y: 2)
//                }
//
//                VStack(alignment: .leading) {
//                    Text("Categories")
//                        .font(.title2)
//                        .fontWeight(.semibold)
//                        .padding(.horizontal) // Align text with other sections
//
//                    // Grid for category items
//                    LazyVGrid(columns: categoryColumns, spacing: 16) {
//                        ForEach(categories) { category in
//                            CategoryItemView(categoryName: category.name)
//                        }
//                    }
//                    .padding(.horizontal) // Padding for the grid container
//                }
//
//                Spacer() // Pushes content to the top if screen is large
//
//            } // End of main VStack
//            .padding(.top) // Add some padding at the very top
//
//        } // End of ScrollView
//        .background(Color.orange.opacity(0.2).ignoresSafeArea()) // Light orange background for the whole screen
//        .navigationTitle("Home") // Optional: If used within a NavigationView
//        .navigationBarHidden(true) // Hide navigation bar if it's the root view
//    }
//}
//
//// --- Subview for Category Items ---
//struct CategoryItemView: View {
//    let categoryName: String
//
//    var body: some View {
//        VStack(alignment: .leading) {
//            Rectangle()
//                .fill(Color.gray.opacity(0.4))
//                .frame(height: 10)
//            Rectangle()
//                .fill(Color.gray.opacity(0.4))
//                .frame(height: 10)
//                .padding(.trailing, 30) // Make second line shorter
//             // You'd replace these placeholders with actual text or icons
//             // Text(categoryName).font(.caption).fontWeight(.medium)
//        }
//        .padding()
//        .frame(maxWidth: .infinity, minHeight: 80) // Ensure consistent size
//        .background(Color(UIColor.systemGray6)) // Light background for item
//        .cornerRadius(10)
//        .overlay(
//            RoundedRectangle(cornerRadius: 10)
//                .stroke(Color.orange, lineWidth: 1) // Orange border
//        )
//    }
//}
//
//
#Preview {
    HomePageView()
}

