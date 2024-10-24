//
//  TabBarView.swift
//  virtual-library
//
//  Created by Riley Jenum on 17/10/24.
//

import SwiftUI

struct TabBarView: View {
    
    @State private var activeTab: MainTab = .home
    @State private var isTabBarHidden: Bool = false

    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                if #available(iOS 18, *) {
                    TabView(selection: $activeTab) {
                        Tab.init(value: .home) {
                            Text("Home")
                                .toolbarVisibility(.hidden, for: .tabBar)
                        }
                        
                        Tab.init(value: .search) {
                            DiscoverView()
                                .toolbarVisibility(.hidden, for: .tabBar)

                        }
                        
                        Tab.init(value: .notifications) {
                            Text("Notifications")
                                .toolbarVisibility(.hidden, for: .tabBar)

                        }
                        
                        Tab.init(value: .settings) {
                            Text("Settings")
                                .toolbarVisibility(.hidden, for: .tabBar)

                        }
                    }
                } else {
                    TabView(selection: $activeTab) {
                        Text("Home")
                            .tag(MainTab.home)
                        
                        DiscoverView()
                            .tag(MainTab.search)

                        
                        Text("Notifications")
                            .tag(MainTab.notifications)

                        
                        Text("Settings")
                            .tag(MainTab.settings)

                        
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: 60)
            }
            
            CustomTabBar(activeTab: $activeTab)
                .frame(height: 60)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

struct HideTabBar: UIViewRepresentable {
    var result: () -> ()
    func makeUIView(context: Context) -> some UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        DispatchQueue.main.async {
            if let tabController = view.tabController {
                tabController.tabBar.isHidden = true
                result()
            }
        }
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

extension UIView {
    var tabController: UITabBarController? {
        if let controller = sequence(first: self, next: {
            $0.next
        }).first(where: { $0 is UITabBarController}) as? UITabBarController {
            return controller
        }
        
        return nil
    }
}

#Preview {
    TabBarView()
}
