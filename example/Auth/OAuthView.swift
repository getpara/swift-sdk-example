//
//  OAuthView.swift
//  example
//
//  Created by Brian Corbin on 2/9/25.
//

import SwiftUI
import ParaSwift
import AuthenticationServices

struct OAuthView: View {
    @EnvironmentObject var paraManager: ParaManager
    @EnvironmentObject var appRootManager: AppRootManager
    
    @Environment(\.openURL) private var openURL
    @Environment(\.authorizationController) private var authorizationController
    @Environment(\.webAuthenticationSession) private var webAuthenticationSession
    
    @State private var email = ""
    @State private var shouldNavigateToVerificationView = false
    
    private func login(provider: OAuthProvider) {
        Task {
            do {
                let email = try await paraManager.oAuthConnect(provider: provider, deeplinkUrl: "paraswiftexample", webAuthenticationSession: webAuthenticationSession)
                handleLogin(email: email)
            } catch {
                print("Something went wrong")
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
            Button {
                login(provider: .google)
            } label: {
                Text("Login with Google")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            
            
            Button {
                login(provider: .discord)
            } label: {
                Text("Login with Discord")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            
            Button {
                login(provider: .apple)
            } label: {
                Text("Login with Apple")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .padding()
        .navigationDestination(isPresented: $shouldNavigateToVerificationView) {
            VerifyEmailView(email: email)
                .environmentObject(paraManager)
                .environmentObject(appRootManager)
        }
    }
}

#Preview {
    OAuthView().environmentObject(ParaManager(environment: .sandbox, apiKey: "preview-key"))
        .environmentObject(AppRootManager())
}
