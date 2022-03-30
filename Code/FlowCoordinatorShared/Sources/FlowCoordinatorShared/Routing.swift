//
//  File.swift
//  
//
//  Created by Rusty Zarse on 3/11/22.
//

import Foundation

public struct Routing: Codable, Equatable {
    public var selectedTab: Tab
    public var selectedProfileID: String?

    public init(
        selectedTab: Tab,
        selectedProfileID: String?
    ) {
        self.selectedTab = selectedTab
        self.selectedProfileID = selectedProfileID
    }

    /// Returns a copy of self reset to root tab states
    public func reset(tabs: [Tab] = Tab.allCases) -> Routing {
        tabs.reduce(self) { previousRoutingState, tab in
            previousRoutingState.reset(tab: tab)
        }
    }

    /// Returns a copy of self with specified tab reset to root state
    public func reset(tab: Tab) -> Routing {
        switch tab {
        case .profile:
            var routingCopy = self
            routingCopy.selectedProfileID = nil
            return routingCopy
        case.home:
            // nothing to do
            return self
        }
    }
}
