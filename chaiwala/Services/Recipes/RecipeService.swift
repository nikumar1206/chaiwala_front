//
//  RecipeService.swift
//  chaiwala
//
//  Created by Nikhil Kumar on 4/11/25.
//
import SwiftUI

class RecipeService {
    static let shared = RecipeService()
    
    func getRecipes() async -> Result<[Recipe], NetworkError> {
        let res: Result<[Recipe], NetworkError> = await APIClient.shared.request(
            method: "GET",
            path: "/recipes",
            headers: AuthService.shared.constructHeaders()
        )
        return res
    }
    
    func getRecipe(id: Int) async -> Result<Recipe, NetworkError> {
        let res: Result<Recipe, NetworkError> = await APIClient.shared.request(
            method: "GET",
            path: "/recipes/(id)",
            headers: AuthService.shared.constructHeaders()
        )
        return res
    }

    func createRecipe(r : RecipeDraft) async -> Result<Recipe, NetworkError> {
        let res: Result<Recipe, NetworkError> = await APIClient.shared.request(
            method: "POST",
            path: "/recipes",
            body: r,
            headers: AuthService.shared.constructHeaders(),
        )
        return res
    }
    
    func getImage(fileId: String) async -> Result<UIImage, NetworkError> {
        let res: Result<UIImage, NetworkError> = await APIClient.shared.requestImage(
            path: "/files/\(fileId)",
            headers: AuthService.shared.constructHeaders(),
        )
        return res
    }

}
