import Foundation

public class CardConfigManager: CardConfigManaging {
    public init() {}
    
    public func loadConfig(from filename: String, bundle: Bundle = .main) -> Result<[CardConfig], CardConfigError> {
        guard let url = bundle.url(forResource: filename, withExtension: "json") else {
            let message = "❌ Could not find file \(filename).json in bundle."
            return .failure(.fileNotFound(message))
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let configs = try decoder.decode([CardConfig].self, from: data)
            return .success(configs)
        } catch {
            let message = "❌ Error decoding JSON from \(filename).json: \(error.localizedDescription)"
            return .failure(.decodingFailed(message))
        }
    }
}
