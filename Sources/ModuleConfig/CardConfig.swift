import Foundation

import Foundation

public struct CardConfig: Codable {
    public let credit: CardTypeConfig?
    public let debit: CardTypeConfig?
}

public struct CardTypeConfig: Codable {
    public let cardNumberDisplay: Bool?
    public let cardNameDisplay: Bool?
    public let disabled: Bool?
}


public enum CardConfigError: Error, CustomStringConvertible {
    case fileNotFound(String)
    case decodingFailed(String)
    
    public var description: String {
        switch self {
            case .fileNotFound(let file):
                return "❌ Could not find file \(file).json in bundle."
            case .decodingFailed(let message):
                return "❌ Error decoding JSON: \(message)"
        }
    }
}
