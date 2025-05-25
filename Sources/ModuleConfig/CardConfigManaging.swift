import Foundation

public protocol CardConfigManaging {
    func loadConfig(from filename: String, bundle: Bundle) -> Result<CardConfig, CardConfigError>
}
