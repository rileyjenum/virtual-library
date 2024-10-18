//
//  CustomTabBar.swift
//  virtual-library
//
//  Created by Riley Jenum on 17/10/24.
//

import SwiftUI

struct CustomTabBar: View {
    var activeForeground: Color = .white
    var activeBackground: Color = .black
    @Binding var activeTab: MainTab
    @State private var tabLocation: CGRect = .zero

    @Namespace private var animation
    var body: some View {
        HStack(spacing: 0) {
            ForEach(MainTab.allCases, id: \.rawValue) { tab in
                Button {
                    activeTab = tab
                } label: {
                    HStack(spacing: 5) {
                        Image(systemName: tab.rawValue)
                            .font(.title3)
                            .frame(width: 30, height: 30)
                        
                        if activeTab == tab {
                            Text(tab.title)
                                .font(.caption)
                                .fontWeight(.semibold)
                                .lineLimit(1)
                        }
                    }
                    .padding(.vertical, 2)
                    .padding(.leading, 10)
                    .padding(.trailing, 15)
                    .contentShape(.rect)
                    .foregroundStyle(activeTab == tab ? activeForeground : .gray)
                    .background {
                        if activeTab == tab {
                            Capsule()
                                .fill(.clear)
                                .onGeometryChange(for: CGRect.self, of: {
                                    $0.frame(in: .named("tabBarView"))
                                }, action: { newValue in
                                    tabLocation = newValue
                                })
                                .matchedGeometryEffect(id: "activeMainTab", in: animation)
                        }
                    }


                }
                .buttonStyle(.plain)
            }
        }
        .background(alignment: .leading) {
            Capsule()
                .fill(activeBackground.gradient)
                .frame(width: tabLocation.width, height: tabLocation.height)
                .offset(x: tabLocation.minX)
        }
        .coordinateSpace(.named("tabBarView"))
        .padding(.horizontal, 5)
        .frame(height: 45)
        .background(
            .background
                .shadow(.drop(color: .black.opacity(0.08), radius: 5, x: 5, y: 5))
                .shadow(.drop(color: .black.opacity(0.06), radius: 5, x: -5, y: -5)),
            in: .capsule

        )
        .animation(.smooth(duration: 0.3, extraBounce: 0), value: activeTab)
    }
}

#Preview {
    TabBarView()
}
