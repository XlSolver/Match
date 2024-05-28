//
//  SignOut.swift
//  Match!
//
//  Created by Salvatore Flauto on 23/05/24.
//

import SwiftUI
import FirebaseAuth

struct SignOut: View {
    @AppStorage ("log_status") private var logStatus: Bool = false
    var body: some View {
        NavigationStack {
            Button("Logout") {
                try? Auth.auth().signOut()
                print("Calling signOut")
                logStatus = false
            }
            .navigationTitle("Logout view")
        }
    }
}

#Preview {
    SignOut()
}
