//
//  ExternalWalletAuthView.swift
//  ParaSample
//
//  Created by Tyson Williams on 2/7/25.
//

import SwiftUI
import ParaSwift

struct ExternalWalletAuthView: View {
    @EnvironmentObject private var paraManager: ParaManager
    @EnvironmentObject private var appRootManager: AppRootManager
    @EnvironmentObject private var metaMaskConnector: MetaMaskConnector
    
    @State private var isConnecting = false
    @State private var error: Error?
    @State private var showError = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Connect with External Wallet")
                .font(.title2)
                .fontWeight(.bold)
            
            Button(action: connectMetaMask) {
                HStack {
                    Image(systemName: "link.circle.fill")
                        .font(.title2)
                    Text("Connect MetaMask")
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .disabled(isConnecting)
            
            if isConnecting {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            }
        }
        .padding()
        .alert("Connection Error", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(error?.localizedDescription ?? "Unknown error occurred")
        }
    }
    
    private func connectMetaMask() {
        isConnecting = true
        
        Task {
            do {
                try await metaMaskConnector.connect()
                // On successful connection, MetaMask will handle the external wallet login
                // and the ParaManager's sessionState will be updated
                if paraManager.sessionState == .activeLoggedIn {
                    appRootManager.currentRoot = .home
                }
            } catch {
                self.error = error
                self.showError = true
            }
            isConnecting = false
        }
    }
}

#Preview {
    ExternalWalletAuthView()
        .environmentObject(ParaManager(environment: .sandbox, apiKey: "preview-key"))
        .environmentObject(AppRootManager())
        .environmentObject(MetaMaskConnector(
            para: ParaManager(environment: .sandbox, apiKey: "preview-key"),
            appUrl: "https://example.com",
            deepLink: "example-app",
            config: MetaMaskConfig(appName: "Example App", appId: "example-app")
        ))
}
