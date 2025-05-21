//
//  AuthManager.swift
//  chaiwala
//
//  Created by Nikhil Kumar on 4/27/25.
//
import UIKit
import SwiftUI

class AuthManager {
    static let shared = AuthManager()
    

    func logoutAndRedirectToLogin() {
        KeychainHelper.shared.clearAll()

        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first else {
                print("No active window found.")
                return
            }

            let loginView = RegisterLoginView()
            let hostingController = UIHostingController(rootView: loginView)

            // Set the root view controller to the LoginView
            window.rootViewController = hostingController
            window.makeKeyAndVisible()
        }
    }
}
