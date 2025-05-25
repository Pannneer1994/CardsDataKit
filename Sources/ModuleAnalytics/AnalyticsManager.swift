import Foundation

public class AnalyticsManager: AnalyticsManaging {
    public init() {}

    public func track(event: String, parameters: [String: Any]? = nil) {
        print("Tracked event: \(event) with parameters: \(parameters ?? [:])")
    }
}