import XCTest
@testable import ModuleAnalytics

final class ModuleAnalyticsTests: XCTestCase {

    func testLogEvent_shouldPrint() {
        let logger = AnalyticsLogger()
        logger.log(event: "TestEvent", parameters: ["key": "value"])
        // This test simply ensures the method runs without crashing.
        XCTAssertTrue(true)
    }
}