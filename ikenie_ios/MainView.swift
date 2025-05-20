//
//  ContentView.swift
//  ikenie_ios
//
//  Created by 塩見陵介 on 2024/07/01.
//

import SwiftUI

enum Tabs: Int, CaseIterable {
    case home = 0
    case favorites
    case settings
    
    var iconName: String {
        switch self {
        case .home:
            return "house"
        case .favorites:
            return "bookmark"
        case .settings:
            return "gearshape"
        }
    }
    
    @ViewBuilder
    func view() -> some View {
        switch self {
            case .home:
            HomeView()
        case .favorites:
            GithubView()
        case .settings:
            StudyTaskAppView()
        }
    }
}

struct MainView: View {
    
    @State private var selectedTab: Tabs = .home
    
    init() {
        UITabBar.appearance().unselectedItemTintColor = UIColor.systemBlue
    }
    
    var body: some View {
        TabView {
            ForEach(Tabs.allCases, id: \.self) { tab in
                tab.view()
                    .tabItem {
                        Image(systemName: tab.iconName)
                    }
                    .tag(tab)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .tint(.red)
        
    }
}

#Preview {
    MainView()
}
