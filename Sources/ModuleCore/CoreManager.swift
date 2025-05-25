import Foundation
import ModuleNetworking
import ModuleAnalytics
import ModuleConfig

// MARK: - Card Model

public struct Card: Codable {
    public let bankName: String
    public let cardType: String
    public let cardNumber: String
    public let cardHolderName: String
    public let cardImage: String
    public let cardBlocked: Bool
}

// MARK: - CoreManager

public class CoreManager: CoreManaging {
    
    private let networkingManager: NetworkingManaging
    private let analyticsManager: AnalyticsManaging
    private let configManager: CardConfigManaging
    
    // MARK: - Init
    
    public init(
        networkingManager: NetworkingManaging,
        analyticsManager: AnalyticsManaging,
        configManager: CardConfigManaging
    ) {
        self.networkingManager = networkingManager
        self.analyticsManager = analyticsManager
        self.configManager = configManager
    }
    
    // MARK: - Execute Logic in Parallel (Config + Network)
    
    public func fetchCardList(
        with url: URL,
        configFileName: String,
        completion: @escaping ([Card]?, String?) -> Void
    ) {
        let dispatchGroup = DispatchGroup()
        var loadedConfigs: CardConfig?
        var fetchedData: Data?
        var fetchError: String?
        
        // Load Config
        dispatchGroup.enter()
        DispatchQueue.global(qos: .userInitiated).async {
            defer { dispatchGroup.leave() }
            switch self.configManager.loadConfig(from: configFileName, bundle: .main) {
                case .success(let config):
                    print("✅ Loaded card config.")
                    self.analyticsManager.track(event: "configLoaded", parameters: [:])
                    loadedConfigs = config
                case .failure(let error):
                    print("❌ Config load failed: \(error.localizedDescription)")
                    self.analyticsManager.track(event: "configLoadFailed", parameters: ["filename": configFileName])
                    fetchError = error.localizedDescription
            }
        }
        
        // Fetch Network Data
        dispatchGroup.enter()
        networkingManager.fetchData(from: url) { result in
            defer { dispatchGroup.leave() }
            switch result {
                case .success(let data):
                    print("✅ Data fetched: \(data.count) bytes")
                    self.analyticsManager.track(event: "dataFetched", parameters: ["size": data.count])
                    fetchedData = data
                case .failure(let error):
                    let errorMsg = "❌ Fetch failed: \(error.localizedDescription)"
                    print(errorMsg)
                    self.analyticsManager.track(event: "fetchFailed", parameters: ["url": url.absoluteString])
                    fetchError = error.localizedDescription
            }
        }
        
        // Notify when both tasks finish
        dispatchGroup.notify(queue: .main) {
            guard let config = loadedConfigs, let data = fetchedData else {
                return completion(nil, fetchError ?? "Unknown error")
            }
            do {
                let cards = try JSONDecoder().decode([Card].self, from: data)
                let filtered = self.filter(cards: cards, using: config)
                completion(filtered, nil)
            } catch {
                completion(nil, "❌ Decoding failed: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Filter Cards Based on Config
    
    public func filter(cards: [Card], using config: CardConfig) -> [Card] {
        let filteredCards = cards.compactMap { card -> Card? in
            guard let typeConfig = config.config(for: card.cardType),
                  typeConfig.disabled != true else {
                return nil
            }
            
            let maskedNumber = typeConfig.cardNumberDisplay == false ? "**** **** **** ****" : card.cardNumber
            let maskedName = typeConfig.cardNameDisplay == false ? "****" : card.cardHolderName
            
            return Card(
                bankName: card.bankName,
                cardType: card.cardType,
                cardNumber: maskedNumber,
                cardHolderName: maskedName,
                cardImage: card.cardImage,
                cardBlocked: card.cardBlocked
            )
        }
        
        print("✅ Filtered cards count: \(filteredCards.count)")
        analyticsManager.track(event: "cardsFiltered", parameters: ["count": filteredCards.count])
        return filteredCards
    }
}

// MARK: - CoreManaging Protocol

public protocol CoreManaging {
    func fetchCardList(
        with url: URL,
        configFileName: String,
        completion: @escaping ([Card]?, String?) -> Void
    )
}

// MARK: - CardConfig Extension

private extension CardConfig {
    /// Returns type-specific config for a given cardType string
    func config(for type: String) -> CardTypeConfig? {
        switch type.lowercased() {
            case "credit": return credit
            case "debit": return debit
            default: return nil
        }
    }
}

