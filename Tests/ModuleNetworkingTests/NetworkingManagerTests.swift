import XCTest
@testable import ModuleNetworking

final class NetworkingManagerTests: XCTestCase {
    func testFetchDataSuccess() {
        let expectation = self.expectation(description: "Data fetched")
        let manager = NetworkingManager()
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts/1")!

        manager.fetchData(from: url) { result in
            switch result {
            case .success(let data):
                XCTAssertGreaterThan(data.count, 0)
            case .failure(let error):
                XCTFail("Expected success, got error: \(error)")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }
}