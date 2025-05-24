import XCTest
@testable import ModuleNetworking

final class ModuleNetworkingTests: XCTestCase {

    func testRequest_withInvalidURL_shouldFail() {
        let networkManager = NetworkManager()
        let expectation = self.expectation(description: "Invalid URL should return failure")

        networkManager.request(url: "invalid-url") { result in
            switch result {
            case .success:
                XCTFail("Request with invalid URL should not succeed")
            case .failure:
                XCTAssertTrue(true)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2)
    }
}