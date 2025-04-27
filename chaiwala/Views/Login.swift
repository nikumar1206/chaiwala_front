//
//  Login.swift
//  chaiwala
//
//  Created by Nikhil Kumar on 4/6/25.
//


import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoggingIn: Bool = false
    @State private var loginError: String? = nil
    @State private var isLoggedIn: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [deepAmber, deepAmber.opacity(0.7)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
                
                // Decorative circles
                Circle()
                    .fill(deepAmber.opacity(0.3))
                    .frame(width: 200, height: 200)
                    .offset(x: -120, y: -180)
                
                Circle()
                    .fill(cinnamonBrown.opacity(0.2))
                    .frame(width: 150, height: 150)
                    .offset(x: 150, y: -100)
                
                ScrollView {
                    VStack(spacing: 20) {
                        Spacer(minLength: 60)
                        
                        // Logo Container
                        Circle()
                            .fill(Color.white.opacity(0.95))
                            .frame(width: 160, height: 160)
                            .overlay(
                                VStack(spacing: 0) {
                                    Text("chai")
                                        .font(.custom("Winky Sans", size: 32))
                                        .fontWeight(.semibold)
                                        .foregroundColor(deepAmber)
                                    
                                    Text("wala")
                                        .font(.custom("Winky Sans", size: 32))
                                        .fontWeight(.semibold)
                                        .foregroundColor(cinnamonBrown)
                                }
                            )
                            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                        
                        // Tagline
                        VStack(spacing: 5) {
                            Text("A journey through the world's")
                                .font(.custom("Winky Sans", size: 18))
                                .foregroundColor(.white)
                            
                            Text("finest tea traditions")
                                .font(.custom("Winky Sans", size: 18))
                                .foregroundColor(.white)
                        }
                        .padding(.top, 10)
                        .padding(.bottom, 40)
                        
                        // Login Form
                        VStack(spacing: 20) {
                            // Email field
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Email Address")
                                    .font(.custom("Winky Sans", size: 14))
                                    .foregroundColor(cinnamonBrown)
                                    .padding(.leading, 4)
                                
                                TextField("", text: $email)
                                    .padding()
                                    .background(warmCream)
                                    .cornerRadius(8)
                                    .textInputAutocapitalization(.never)
                                    .disableAutocorrection(true)
                                    .keyboardType(.emailAddress)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color(hex: "E0D9C5"), lineWidth: 1)
                                    )
                            }
                            
                            // Password field
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Password")
                                    .font(.custom("Winky Sans", size: 14))
                                    .foregroundColor(cinnamonBrown)
                                    .padding(.leading, 4)
                                
                                SecureField("", text: $password)
                                    .padding()
                                    .background(warmCream)
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color(hex: "E0D9C5"), lineWidth: 1)
                                    )
                            }
                            
                            // Error message if any
                            if let error = loginError {
                                Text(error)
                                    .font(.system(size: 14))
                                    .foregroundColor(terracotta)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                            }
                            
                            // Sign In button
                            Button(action: {
                                Task {
                                    await login(username: email, password: password)
                                }
                            }) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(softChai)
                                    
                                    Text(isLoggingIn ? "Signing In..." : "Sign In")
                                        .font(.custom("Winky Sans", size: 16))
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .padding()
                                }
                                .frame(height: 50)
                            }
                            .disabled(isLoggingIn)
                            .padding(.top, 10)
                            
                            // Sign up link
                            HStack {
                                Text("New to Chaiwala?")
                                    .font(.custom("Winky Sans", size: 14))
                                    .foregroundColor(cinnamonBrown.opacity(0.8))
                                
                                Button(action: {
                                    // Action for sign up
                                }) {
                                    Text("Sign up")
                                        .font(.custom("Winky Sans", size: 14))
                                        .fontWeight(.bold)
                                        .foregroundColor(softChai)
                                }
                            }
                            .padding(.top, 5)
                            
                        }
                        .padding(30)
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 10)
                        .padding(.horizontal, 20)
                        
                        Spacer(minLength: 40)
                    }
                }

                // Navigation link to home page when logged in
                NavigationLink(destination: LandingPageView(), isActive: $isLoggedIn) {
                    EmptyView()
                }
                .hidden()
            }
            .navigationBarHidden(true)
        }
    }
    
    func login(username: String, password: String) async {
        isLoggingIn = true
        loginError = nil
        
        let result = await AuthService.shared.login(username: username, password: password)
        
        switch result {
        case .success(let authResponse):
            // Handle successful login (e.g., navigate to the next screen)
            print("Logged in with token: \(authResponse.token) \(authResponse.user)")
            isLoggedIn = true
            print("what is logged in", $isLoggedIn)
            
        case .failure(let error):
            // Handle error
            loginError = error.localizedDescription
        }
        
        isLoggingIn = false
    }

}


#Preview {
    LoginView()
}
