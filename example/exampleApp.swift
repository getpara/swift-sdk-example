import SwiftUI
import ParaSwift

@main
struct exampleApp: App {
    @StateObject private var paraManager: ParaManager
    @StateObject private var paraEvmSigner: ParaEvmSigner
    @StateObject private var appRootManager = AppRootManager()
    
    init() {
        let environmentString = ProcessInfo.processInfo.environment["PARA_ENVIRONMENT"] ?? "beta"
        
        let environment: ParaEnvironment = environmentString == "sandbox" ? .sandbox : .beta
        
        let apiKey = ProcessInfo.processInfo.environment["PARA_API_KEY"] ?? ""
        
        let paraManager = ParaManager(environment: environment, apiKey: apiKey)
        
        _paraManager = StateObject(wrappedValue: paraManager)
        _paraEvmSigner = StateObject(wrappedValue: try! ParaEvmSigner(paraManager: paraManager, rpcUrl: "https://sepolia.infura.io/v3/961364684c7346c080994baab1469ea8", walletId: nil))
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

