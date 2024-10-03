import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import GoogleSignIn

struct SettingsView: View {
    @State private var profileName: String = ""
    @State private var email: String = ""
    @State private var errorMessage: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Color.black
                .ignoresSafeArea()
            // Profile Information
            VStack(alignment: .leading, spacing: 10) {
                Text("Profile Information")
                    .font(.headline)
                    .foregroundColor(.orange)
                
                Text("Name: \(profileName)")
                    .foregroundColor(.white)
                    .font(.title3)
                
                Text("Email: \(email)")
                    .foregroundColor(.white)
                    .font(.title3)
            }
            .padding()
            
            // Error Message
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
            Spacer()
            
            // Log Out Button
            Button(action: logOut) {
                Text("Log Out")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.orange)
                    .cornerRadius(10)
            }
            .padding(.bottom, 50)
        }
        .background(Color.black.ignoresSafeArea())
        .onAppear(perform: checkAuthState) // Check if user is logged in
    }
    
    // Check Firebase Auth State
    func checkAuthState() {
        Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                self.email = user.email ?? "No email"
                fetchProfileData(userId: user.uid)
            } else {
                self.errorMessage = "No user is logged in"
            }
        }
    }
    
    // Fetch profile data from Firestore
    func fetchProfileData(userId: String) {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userId)
        
        userRef.getDocument { (document, error) in
            if let error = error {
                self.errorMessage = "Error fetching profile: \(error.localizedDescription)"
            } else if let document = document, document.exists {
                if let data = document.data() {
                    self.profileName = data["name"] as? String ?? "No name"
                    self.email = data["email"] as? String ?? "No email"
                } else {
                    self.errorMessage = "No profile data found"
                }
            } else {
                self.errorMessage = "No profile found for this user"
            }
        }
    }
    
    // Log out user
    func logOut() {
        do {
            try Auth.auth().signOut()
            // You can add navigation logic here if needed, like returning to a login screen
        } catch let signOutError as NSError {
            self.errorMessage = "Error signing out: \(signOutError.localizedDescription)"
        }
    }
}

#Preview {
    SettingsView()
}
