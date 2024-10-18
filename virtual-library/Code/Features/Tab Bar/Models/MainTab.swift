//
//  MainTab.swift
//  virtual-library
//
//  Created by Riley Jenum on 17/10/24.
//

enum MainTab: String, CaseIterable {
    
    case home = "house"
    case search = "magnifyingglass"
    case notifications = "bell"
    case settings = "gearshape"
    
    var title: String {
        switch self {
        case .home: "Home"
        case .notifications: "Notifications"
        case .search: "Search"
        case .settings: "Settings"
        }
    }
}
