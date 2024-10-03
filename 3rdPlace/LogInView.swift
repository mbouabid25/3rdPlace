import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import GoogleSignIn
import GoogleSignInSwift

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var loginErrorMessage: String?
    @State private var isLoggingIn = false
    @State private var isLoggedIn = false // Track login status
    @State private var isSignUpMode = false // Toggle between login and sign-up

    var body: some View {
        ZStack {
            // Black background
            Color.black
                .ignoresSafeArea()

            if isLoggedIn {
                // Navigate to the main app content if logged in
                HomeView()
            } else {
                VStack(spacing: 20) {
                    Spacer()

                    // Title
                    Text(isSignUpMode ? "Sign Up" : "Login")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.bottom, 40)

                    // Email TextField
                    VStack(spacing: 10) {
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            )

                        // Password SecureField
                        SecureField("Password", text: $password)
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            )
                    }
                    .padding(.horizontal, 40)

                    // Error message display
                    if let errorMessage = loginErrorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                    }

                    Spacer()

                    // Loading indicator or Log In/Sign Up button
                    if isLoggingIn {
                        ProgressView() // Display progress while logging in
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .padding()
                    } else {
                        Button(action: isSignUpMode ? signUpUser : loginUser) {
                            Text(isSignUpMode ? "Sign Up" : "Log In")
                                .font(.headline)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                        }
                        .disabled(isLoggingIn) // Disable button while logging in
                        .padding(.horizontal, 40)

                        // Toggle between Login and Sign Up
                        Button(action: {
                            isSignUpMode.toggle()
                        }) {
                            Text(isSignUpMode ? "Already have an account? Log In" : "Don't have an account? Sign Up")
                                .foregroundColor(.white)
                                .padding()
                        }
                    }

                    Spacer()
                }
                .padding()
            }
        }
    }

    // Firebase login function
    func loginUser() {
        // Reset error message and set logging in state
        loginErrorMessage = nil
        isLoggingIn = true
        
        // Firebase login
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                // Handle the login error
                loginErrorMessage = error.localizedDescription
                isLoggingIn = false
            } else {
                // Successfully logged in
                isLoggingIn = false
                isLoggedIn = true // Set the logged-in state
            }
        }
    }

    // Firebase sign-up function with Firestore save
    func signUpUser() {
        // Reset error message and set logging in state
        loginErrorMessage = nil
        isLoggingIn = true
        
        // Firebase sign-up
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                // Handle the sign-up error
                loginErrorMessage = error.localizedDescription
                isLoggingIn = false
            } else if let authResult = authResult {
                // Successfully signed up
                saveUserProfile(uid: authResult.user.uid) // Save to Firestore
                isLoggingIn = false
                isLoggedIn = true // Set the logged-in state
            }
        }
    }

    // Save user profile to Firestore
    func saveUserProfile(uid: String) {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(uid)
        
        userRef.setData([
            "email": email,
            "createdAt": Timestamp(date: Date())
        ]) { error in
            if let error = error {
                print("Error saving user profile: \(error.localizedDescription)")
            } else {
                print("User profile saved successfully!")
            }
        }
    }

    // Helper function to get the root view controller
    func getRootViewController() -> UIViewController {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            fatalError("Unable to get the root view controller")
        }
        return rootViewController
    }
}

#Preview {
    LoginView()
}
