// CoreManager.swift

import Foundation
import ModuleNetworking
import ModuleAnalytics
import ModuleConfig

public class CoreManager: CoreManaging {
    private let networkingManager: NetworkingManaging
    private let analyticsManager: AnalyticsManaging
    private let configManager: CardConfigManaging
    
    public init(
        networkingManager: NetworkingManaging,
        analyticsManager: AnalyticsManaging,
        configManager: CardConfigManaging
    ) {
        self.networkingManager = networkingManager
        self.analyticsManager = analyticsManager
        self.configManager = configManager
    }
    
    public func executeCoreLogic(
        with url: URL,
        configFileName: String,
        completion: @escaping ([CardConfig]?, String?) -> Void
    ) {
        switch configManager.loadConfig(from: configFileName, bundle: .main) {
            case .success(let configs):
                print("✅ Loaded \(configs.count) card configs.")
                analyticsManager.track(event: "configLoaded", parameters: ["count": configs.count])
                
                networkingManager.fetchData(from: url) { result in
                    switch result {
                        case .success(let data):
                            print("✅ Data fetched successfully. Size: \(data.count) bytes")
                            self.analyticsManager.track(event: "dataFetched", parameters: ["size": data.count])
                            completion(configs, nil)
                        case .failure(let error):
                            let errorMessage = "❌ Failed to fetch data from URL: \(url). Error: \(error.localizedDescription)"
                            print(errorMessage)
                            self.analyticsManager.track(event: "fetchFailed", parameters: [
                                "url": url.absoluteString,
                                "error": error.localizedDescription
                            ])
                            completion(configs, errorMessage)
                    }
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                analyticsManager.track(event: "configLoadFailed", parameters: ["filename": configFileName])
                completion(nil, error.localizedDescription)
        }
    }
}


public protocol CoreManaging {
    func executeCoreLogic(
        with url: URL,
        configFileName: String,
        completion: @escaping ([CardConfig]?, String?) -> Void
    )
}
