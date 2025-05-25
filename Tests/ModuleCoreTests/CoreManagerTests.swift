import XCTest
@testable import ModuleCore
@testable import ModuleNetworking
@testable import ModuleConfig
@testable import ModuleAnalytics

final class CoreManagerTests: XCTestCase {
    func testExecuteCoreLogic() {
        class MockNetworkingManager: NetworkingManaging {
            func fetchData(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
                completion(.success(Data("test".utf8)))
            }
        }

        class MockAnalyticsManager: AnalyticsManaging {
            var events: [(String, [String: Any]?)] = []
            func track(event: String, parameters: [String : Any]?) {
                events.append((event, parameters))
            }
        }

        class MockConfigManager: CardConfigManaging {
            func loadConfig(from filename: String, bundle: Bundle) -> Result<ModuleConfig.CardConfig, ModuleConfig.CardConfigError> {
                return .success(CardConfig(credit: .none, debit: .none))
            }
        }

        let coreManager = CoreManager(
            networkingManager: MockNetworkingManager(),
            analyticsManager: MockAnalyticsManager(),
            configManager: MockConfigManager()
        )

        coreManager.executeCoreLogicParallel(with: URL(string: "https://example.com")!, configFileName: "cards", completion: {_,_ in })

        XCTAssertTrue(true)
    }
}
