//
//  File.swift
//  
//
//  Created by Rusty Zarse on 3/11/22.
//

import Foundation

public class AppState: ObservableObject {

    @Published public var routing: Routing {
        didSet {
            UserDefaults.standard.routing = routing
        }
    }

    @Published public var userAlert: UserMessage?

    public init() {
        routing = UserDefaults.standard.routing ?? Routing(selectedTab: .home, selectedProfileID: nil)
    }
}

private extension UserDefaults {

    private var userDefaultsRoutingKey: String { "FlowCoordinator.Routing" }

    var routing: Routing? {
        get {
            guard let persistedData = UserDefaults.standard.object(forKey: userDefaultsRoutingKey) as? Data,
                let persistedRouting = try? JSONDecoder().decode(Routing.self, from: persistedData) else {
                    return nil
                }

            return persistedRouting
        }
        set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(encoded, forKey: userDefaultsRoutingKey)
            }
        }
    }
}
