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
                HStack(spacing: 15) {
                    Image(.google)
                        .resizable()
                        .frame(width: 24, height: 24)
                    Text("Login with Google")
                }
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .tint(.primary)
            
            
            Button {
                login(provider: .discord)
            } label: {
                HStack(spacing: 15) {
                    Image(.discord)
                        .resizable()
                        .frame(width: 24, height: 20)
                    Text("Login with Discord")
                }
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .tint(Color(uiColor: UIColor(rgb: 0x5865F2)))
            
            Button {
                login(provider: .apple)
            } label: {
                HStack(spacing: 15) {
                    Image(.apple)
                        .resizable()
                        .frame(width: 24, height: 24)
                    Text("Login with Apple")
                }
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
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
