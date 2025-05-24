import Foundation

public class AnalyticsLogger {
    public init() {}

    public func log(event: String, parameters: [String: Any]?) {
        print("[Analytics] Event: \(event), parameters: \(parameters ?? [:])")
    }
}