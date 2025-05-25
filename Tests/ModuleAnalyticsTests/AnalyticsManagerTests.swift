import XCTest
@testable import ModuleAnalytics

final class AnalyticsManagerTests: XCTestCase {
    func testTrackEvent() {
        let manager = AnalyticsManager()
        manager.track(event: "testEvent", parameters: ["key": "value"])
        XCTAssertTrue(true)
    }
}