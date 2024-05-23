//
//  SignIn.swift
//  Match!
//
//  Created by Salvatore Flauto on 23/05/24.
//  Doc: https://firebase.google.com/docs/auth/ios/apple

import SwiftUI
import AuthenticationServices
import CryptoKit
import Firebase
import FirebaseAuth

struct SignIn: View {
    //Environment variable
    /*------------------------------------------------------*/
    // Unhashed nonce.
    @State private var nonce: String?
    @State private var errorMessage: String = ""
    @State private var showAlert: Bool = false
    @State private var isLoadingFirebaseAuth: Bool = false
    
    @AppStorage ("log_Status") private var logStatus: Bool = false
    
    var body: some View {
        VStack {
            SignInWithAppleButton(.signIn) { request in
                let nonce = randomNonceString()
                self.nonce = nonce
                request.requestedScopes = [.email, .fullName]
                request.nonce = sha256(nonce)
            } onCompletion: { result in
                switch result {
                case .success(let authorization):
                    loginWithFirebase(authorization)
                case .failure(let error):
                    showError(message: error.localizedDescription)
                }
            }
            .frame(maxHeight: .infinity)
            .frame(height: 55)
            //Other signIn option here
        }
        .padding()
        .alert(errorMessage, isPresented: $showAlert) {
            
        }
        .overlay {
            if isLoadingFirebaseAuth {
                loadingScreen()
            }
        }
    }
    
    @ViewBuilder
    func loadingScreen() -> some View {
        ZStack {
            Rectangle()
                .fill(.ultraThinMaterial)
            ProgressView()
                .frame(width: 45, height: 45)
                .background(.background, in: .rect(cornerRadius: 10))
        }
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }
        
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        
        let nonce = randomBytes.map { byte in
            // Pick a random character from the set, wrapping around if needed.
            charset[Int(byte) % charset.count]
        }
        
        return String(nonce)
    }
    
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    func showError(message: String) {
        errorMessage = message
        showAlert.toggle()
        isLoadingFirebaseAuth = false
    }

    
    func loginWithFirebase(_ authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            isLoadingFirebaseAuth = true
              guard let nonce  else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
              }
              guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
              }
              guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
              }
              // Initialize a Firebase credential, including the user's full name.
              let credential = OAuthProvider.appleCredential(withIDToken: idTokenString,
                                                                rawNonce: nonce,
                                                                fullName: appleIDCredential.fullName)
              // Sign in with Firebase.
              Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error {
                  // Error. If error.code == .MissingOrInvalidNonce, make sure
                  // you're sending the SHA256-hashed nonce as a hex string with
                  // your request to Apple.
                    showError(message: error.localizedDescription)
                  return
                }
                // User is signed in to Firebase with Apple.
                // Pushing user to allMatchView
                  logStatus = true
                  isLoadingFirebaseAuth = false
                  
              }
            }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }
}
    
        
    
    
    


#Preview {
    SignIn()
}
