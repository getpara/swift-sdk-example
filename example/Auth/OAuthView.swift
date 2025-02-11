//
//  OAuthView.swift
//  example
//
//  Created by Brian Corbin on 2/9/25.
//

import SwiftUI
import ParaSwift

struct OAuthView: View {
    @EnvironmentObject var paraManager: ParaManager
    @EnvironmentObject var appRootManager: AppRootManager
    
    @Environment(\.openURL) private var openURL
    @Environment(\.authorizationController) private var authorizationController
    
    @State private var email = ""
    @State private var shouldNavigateToVerificationView = false
    
    private func login(provider: OAuthProvider) {
        Task {
            let oAuthURL = try! await paraManager.getOAuthURL(provider: provider, deeplinkUrl: "paraswiftexample")
            if let url = URL(string: oAuthURL) {
                openURL(url)
            }
        }
    }
    
    private func handleLogin(email: String) {
        Task {
            self.email = email
            let userExists = try await paraManager.checkIfUserExists(email: email)
            if userExists {
                try await paraManager.login(authorizationController: authorizationController, authInfo: EmailAuthInfo(email: email))
                appRootManager.currentRoot = .home
            } else {
                try await paraManager.createUser(email: email)
                shouldNavigateToVerificationView = true
            }
        }
    }
    
    var body: some View {
        VStack {
            Button("Login with Google") {
                login(provider: .google)
            }.buttonStyle(.bordered)
            Button("Login with Discord") {
                login(provider: .discord)
            }.buttonStyle(.bordered)
            Button("Login with Apple") {
                login(provider: .apple)
            }.buttonStyle(.bordered)
        }
        .navigationDestination(isPresented: $shouldNavigateToVerificationView) {
            VerifyEmailView(email: email)
                .environmentObject(paraManager)
                .environmentObject(appRootManager)
        }
        .onOpenURL { url in
            guard let email = url.valueOf("email") else {
                return
            }
            
            handleLogin(email: email)
        }
    }
}

#Preview {
    OAuthView()
}
