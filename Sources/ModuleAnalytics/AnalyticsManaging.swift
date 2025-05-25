import Foundation

public protocol AnalyticsManaging {
    func track(event: String, parameters: [String: Any]?)
}