import SwiftUI
import ParaSwift

@main
struct ExampleApp: App {
    @StateObject private var paraManager: ParaManager
    @StateObject private var paraEvmSigner: ParaEvmSigner
    @StateObject private var appRootManager = AppRootManager()
    
    init() {
        // Load Para configuration
        let config = ParaConfig.fromEnvironment()
        
        // Initialize Para manager
        let paraManager = ParaManager(
            environment: config.environment,
            apiKey: config.apiKey
        )
        _paraManager = StateObject(wrappedValue: paraManager)
        
        // Initialize EVM signer
        do {
            let signer = try ParaEvmSigner(
                paraManager: paraManager,
                rpcUrl: config.rpcUrl,
                walletId: nil
            )
            _paraEvmSigner = StateObject(wrappedValue: signer)
        } catch {
            fatalError("Failed to initialize Para EVM signer: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            switch appRootManager.currentRoot {
            case .authentication:
                UserAuthView()
                    .environmentObject(paraManager)
                    .environmentObject(appRootManager)
            case .home:
                WalletsView()
                    .environmentObject(paraManager)
                    .environmentObject(appRootManager)
                    .environmentObject(paraEvmSigner)
            }
        }
    }
}

