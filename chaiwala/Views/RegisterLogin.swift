import SwiftUI

struct RegisterLoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoggingIn: Bool = false
    @State private var loginError: String? = nil
    @State private var isLoggedIn: Bool = false
    @State private var loginPage: Bool = true

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundCream.ignoresSafeArea()
                
                VStack(spacing: 32) {
                    Spacer(minLength: 40)

                    // Logo Text
                    VStack(spacing: -8) {
                        Text("chai")
                            .font(.custom("Winky Sans", size: 36))
                            .foregroundColor(deepAmber)

                        Text("wala")
                            .font(.custom("Winky Sans", size: 36))
                            .foregroundColor(cinnamonBrown)
                    }

                    // Tagline
                    VStack(spacing: 4) {
                        Text("A journey through the world’s")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(ChaiColors.cardamomGreen)

                        Text("finest tea recipes")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(ChaiColors.cardamomGreen)
                    }

                    // Form Card
                    VStack(spacing: 20) {
                        // Email
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Email Address")
                                .font(.caption)
                                .foregroundColor(ChaiColors.cardamomGreen)
                            
                            TextField("", text: $email)
                                .padding()
                                .background(warmCream)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(ChaiColors.saffronGold.opacity(0.3), lineWidth: 1)
                                )
                                .textInputAutocapitalization(.never)
                                .disableAutocorrection(true)
                                .keyboardType(.emailAddress)
                        }

                        // Password
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Password")
                                .font(.caption)
                                .foregroundColor(ChaiColors.cardamomGreen)
                            
                            SecureField("", text: $password)
                                .padding()
                                .background(warmCream)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(ChaiColors.saffronGold.opacity(0.3), lineWidth: 1)
                                )
                        }

                        // Error
                        if let error = loginError {
                            Text(error)
                                .font(.footnote)
                                .foregroundColor(terracotta)
                                .multilineTextAlignment(.center)
                        }

                        // Login/Signup button
                        Button(action: {
                            Task {
                                if loginPage {
                                    await login(email: email, password: password)
                                } else {
                                    await register(email: email, password: password)
                                }
                            }
                        }) {
                            HStack {
                                if isLoggingIn {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                } else {
                                    Text(loginPage ? "Sign In" : "Sign Up")
                                        .font(.system(size: 16, weight: .semibold))
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(softChai)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        .disabled(isLoggingIn)

                        // Toggle Sign in / up
                        HStack(spacing: 4) {
                            Text(loginPage ? "New to Chaiwala?" : "Already a Chaiwala?")
                                .font(.caption)
                                .foregroundColor(ChaiColors.cardamomGreen.opacity(0.8))

                            Button(action: { loginPage.toggle() }) {
                                Text(loginPage ? "Sign Up" : "Sign In")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(ChaiColors.saffronGold)
                            }
                        }
                        .padding(.top, 8)

                    }
                    .padding(24)
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
                    .padding(.horizontal, 24)

                    Spacer()
                }
                .padding(.top)
                
                // Navigation to home
                NavigationLink(destination: HomePageView(), isActive: $isLoggedIn) {
                    EmptyView()
                }
                .hidden()
            }
            .navigationBarHidden(true)
        }
    }

    func login(email: String, password: String) async {
        isLoggingIn = true
        loginError = nil
        let result = await AuthService.shared.login(email: email, password: password)

        switch result {
        case .success:
            isLoggedIn = true
        case .failure(let error):
            loginError = error.localizedDescription
        }

        isLoggingIn = false
    }

    func register(email: String, password: String) async {
        isLoggingIn = true
        loginError = nil
        let result = await AuthService.shared.register(email: email, password: password)

        switch result {
        case .success:
            isLoggedIn = true
        case .failure(let error):
            loginError = error.localizedDescription
        }

        isLoggingIn = false
    }
}

#Preview {
    RegisterLoginView()
}
