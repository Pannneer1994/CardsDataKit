import Foundation

// MARK: - Analytics Manager

/// A simple analytics manager that logs events to the console.
/// Conforms to the `AnalyticsManaging` protocol.
public class AnalyticsManager: AnalyticsManaging {
    
    // MARK: - Initializer
    
    /// Initializes a new instance of `AnalyticsManager`.
    public init() {}
    
    // MARK: - Event Tracking
    
    /// Tracks an event with optional parameters.
    ///
    /// - Parameters:
    ///   - event: The name of the event to track.
    ///   - parameters: A dictionary of additional information to log with the event.
    public func track(event: String, parameters: [String: Any]? = nil) {
        print("📊 Tracked event: \(event) with parameters: \(parameters ?? [:])")
    }
}
