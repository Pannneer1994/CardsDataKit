import XCTest
@testable import ModuleConfig

final class CardConfigManagerTests: XCTestCase {
    var manager: CardConfigManager!
    
    override func setUp() {
        super.setUp()
        manager = CardConfigManager()
    }
    
    func testLoadConfig_Success() {
        // Assume TestCards.json is a valid file in the test bundle.
        let result = manager.loadConfig(from: "TestCards", bundle: Bundle.module)
        
        switch result {
            case .success(let configs):
                XCTAssertFalse(configs.isEmpty, "Expected card configs to be loaded.")
            case .failure(let error):
                XCTFail("Unexpected failure: \(error)")
        }
    }
    
    func testLoadConfig_FileNotFound() {
        let result = manager.loadConfig(from: "NonExistentFile", bundle: Bundle.module)
        
        switch result {
            case .success:
                XCTFail("Expected failure when loading non-existent file.")
            case .failure(let error):
                if case .fileNotFound(let message) = error {
                    XCTAssertTrue(message.contains("Could not find file"), "Expected file not found error.")
                } else {
                    XCTFail("Expected fileNotFound error, got: \(error)")
                }
        }
    }
    
    func testLoadConfig_DecodingFailure() {
        // Assume CorruptCards.json is present but has invalid JSON structure
        let result = manager.loadConfig(from: "CorruptCards", bundle: Bundle.module)
        
        switch result {
            case .success:
                XCTFail("Expected decoding failure.")
            case .failure(let error):
                if case .decodingFailed(let message) = error {
                    XCTAssertTrue(message.contains("Error decoding JSON"), "Expected decoding failure message.")
                } else {
                    XCTFail("Expected decodingFailed error, got: \(error)")
                }
        }
    }
}
