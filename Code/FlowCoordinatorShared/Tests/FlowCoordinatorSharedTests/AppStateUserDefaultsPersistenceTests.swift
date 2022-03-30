import XCTest
@testable import FlowCoordinatorShared

final class AppStateUserDefaultsPersistenceTests: XCTestCase {

    override func setUp() {
        clearUserDefaults()
    }

    private func clearUserDefaults() {
        guard let domain = Bundle.main.bundleIdentifier else { return }
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
    }

    func testRoutingPersists() throws {
        let appState = AppState()
        XCTAssertEqual(Tab.home, appState.routing.selectedTab)
        XCTAssertNil(appState.routing.selectedProfileID)

        appState.routing.selectedProfileID = "test"
        appState.routing.selectedTab = .profile

        XCTAssertEqual(Tab.profile, appState.routing.selectedTab)
        XCTAssertEqual("test", appState.routing.selectedProfileID)

        let newAppState = AppState()
        XCTAssertEqual(Tab.profile, newAppState.routing.selectedTab)
        XCTAssertEqual("test", newAppState.routing.selectedProfileID)

        clearUserDefaults()

        let newNewAppState = AppState()
        XCTAssertEqual(Tab.home, newNewAppState.routing.selectedTab)
        XCTAssertNil(newNewAppState.routing.selectedProfileID)
    }
}
