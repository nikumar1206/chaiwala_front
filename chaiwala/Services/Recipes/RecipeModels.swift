//
//  RecipeModels.swift
//  chaiwala
//
//  Created by Nikhil Kumar on 4/10/25.
//
import Foundation


struct PreparationStepSerializable: Identifiable, Codable {
    let id: Int
    let stepNumber: Int
    let description: String
    let assetId : String?
}

struct RecipeDraft: Identifiable, Codable {
    let id: Int?
    let title: String
    let description: String
    let steps: [PreparationStepSerializable]
    let assetId: String
    let prepTimeMinutes: Int
    let servings: Int
    let isPublic: Bool
    
    
    func getImageURL(fileId: String) -> URL {
        return URL(string: "\(APIClient.host)/files/\(fileId)")!
    }
    
    func getRecipeImageURL() -> URL {
        let res = self.getImageURL(fileId: self.assetId)
        print("image url \(res)")
        return res
    }

}


struct Recipe: Identifiable, Codable {
    let id: Int
    let userId: Int
    let title: String
    let description: String
    let instructions: String
    let assetId: String
    let prepTimeMinutes: Int
    let servings: Int
    let isPublic: Bool
    let createdAt: String
    let updatedAt: String
    
    func createdAtDateTime() -> Date? {
        let dateFormatter = ISO8601DateFormatter()
        return dateFormatter.date(from: self.createdAt)
    }
    func updatedAtDateTime() -> Date? {
        let dateFormatter = ISO8601DateFormatter()
        return dateFormatter.date(from: self.updatedAt)
    }
    
}

struct RecipeWSteps: Identifiable, Codable {
    let id: Int
    let userId: Int
    let title: String
    let description: String
    let steps: [PreparationStepSerializable]
    let assetId: String
    let prepTimeMinutes: Int
    let servings: Int
    let isPublic: Bool
    let createdAt: String
    let updatedAt: String
    
    func createdAtDateTime() -> Date? {
        let dateFormatter = ISO8601DateFormatter()
        return dateFormatter.date(from: self.createdAt)
    }
    func updatedAtDateTime() -> Date? {
        let dateFormatter = ISO8601DateFormatter()
        return dateFormatter.date(from: self.updatedAt)
    }
    
}
