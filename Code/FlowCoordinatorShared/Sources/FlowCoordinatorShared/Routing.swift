//
//  File.swift
//  
//
//  Created by Rusty Zarse on 3/11/22.
//

import Foundation

public struct Routing: Codable {
    public var selectedTab: Tab
    public var selectedProfileID: String?

    public init(
        selectedTab: Tab,
        selectedProfileID: String?
    ) {
        self.selectedTab = selectedTab
        self.selectedProfileID = selectedProfileID
    }
}
