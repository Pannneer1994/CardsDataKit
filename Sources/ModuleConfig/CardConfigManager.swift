import Foundation

// MARK: - CardConfigManaging Implementation

public class CardConfigManager: CardConfigManaging {
    
    // MARK: - Init
    
    public init() {}
    
    // MARK: - Load Config
    
    /// Loads a card configuration from a JSON file in the specified bundle.
    ///
    /// - Parameters:
    ///   - filename: The name of the JSON file (without extension).
    ///   - bundle: The bundle to search for the file. Defaults to `.main`.
    /// - Returns: A result containing either the decoded `CardConfig` or a `CardConfigError`.
    public func loadConfig(from filename: String, bundle: Bundle = .main) -> Result<CardConfig, CardConfigError> {
        // Attempt to locate the file in the given bundle
        guard let url = bundle.url(forResource: filename, withExtension: "json") else {
            let message = "❌ Could not find file \(filename).json in bundle."
            return .failure(.fileNotFound(message))
        }
        
        do {
            // Load the contents of the file into data
            let data = try Data(contentsOf: url)
            
            // Decode the data into a CardConfig object
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let configs = try decoder.decode(CardConfig.self, from: data)
            
            return .success(configs)
        } catch {
            // Return decoding error
            let message = "❌ Error decoding JSON from \(filename).json: \(error.localizedDescription)"
            return .failure(.decodingFailed(message))
        }
    }
}
