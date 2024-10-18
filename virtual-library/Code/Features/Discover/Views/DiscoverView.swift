//
//  DiscoverView.swift
//  virtual-library
//
//  Created by Riley Jenum on 17/10/24.
//

import SwiftUI

struct DiscoverView: View {
    
    @State private var searchText: String = ""
    @State private var activeTab: DiscoverTab = .trending
    @FocusState private var isSearching: Bool
    @Environment(\.colorScheme) private var scheme
    @Namespace private var animation
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 15) {
                DummyMessagesView()
            }
            .safeAreaPadding(15)
            .safeAreaInset(edge: .top, spacing: 0) {
                ExpandableNavigationBar()
            }
            .animation(.snappy(duration: 0.3, extraBounce: 0), value: isSearching)
            
        }
        .scrollTargetBehavior(CustomScrollTargetBehavior())
        .background(.gray.opacity(0.15))
        .contentMargins(.top, 130, for: .scrollIndicators)
    }
    
    // Dummy messages view
    @ViewBuilder
    func ExpandableNavigationBar(_ title: String = "Discover") -> some View {
        GeometryReader {proxy in
            let minY = proxy.frame(in: .scrollView(axis: .vertical)).minY
            let scrollViewHeight = proxy.bounds(of: .scrollView(axis: .vertical))?.height ?? 0
            let scaleProgress = minY > 0 ? 1 + (max(min(minY / scrollViewHeight, 1), 0) * 0.7) : 1
            let progress = isSearching ? 1 : max(min( -minY / 70, 1), 0)
            VStack(spacing: 10) {
                // Title
                Text(title)
                    .font(.largeTitle.bold())
                    .scaleEffect(scaleProgress, anchor: .topLeading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 10)
                
                // Search bar
                HStack(spacing: 12) {
                    Image(systemName: "magnifyingglass")
                        .font(.title3)
                    
                    TextField("Search for a book", text: $searchText) {
                        //
                    }
                    .focused($isSearching)
                    
                    if isSearching {
                        Button {
                            isSearching = false
                        } label: {
                            Image(systemName: "xmark")
                                .font(.title3)
                        }
                        .transition(.asymmetric(insertion: .push(from: .bottom), removal: .push(from: .top)))
                        
                    }
                }
                .foregroundStyle(Color.primary)
                .padding(.horizontal, 15 - (progress * 15))
                .padding(.vertical, 10)
                .frame(height: 45)
                .clipShape(.capsule)
                .background {
                    RoundedRectangle(cornerRadius: 25 - (progress * 25))
                        .fill(.background)
                        .shadow(color: .gray.opacity(0.25), radius: 5, x: 0, y: 5)
                        .padding(.top, -progress * 190)
                        .padding(.horizontal, -progress * 15)
                        .padding(.bottom, -progress * 65)
                    
                }
                
                ScrollView(.horizontal) {
                    HStack(spacing: 12) {
                        ForEach(DiscoverTab.allCases, id: \.rawValue) { tab in
                            Button(action: {
                                withAnimation {
                                    activeTab = tab
                                }
                            }) {
                                Text(tab.rawValue)
                                    .font(.callout)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 15)
                                    .foregroundStyle(activeTab == tab ? (scheme == .dark ? .black : .white) : Color.primary)
                                    .background {
                                        if activeTab == tab {
                                            Capsule()
                                                .fill(Color.primary)
                                                .matchedGeometryEffect(id: "activeDiscoverTab", in: animation)
                                        } else {
                                            Capsule()
                                                .fill(.background)
                                        }
                                    }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .scrollIndicators(.hidden)
                .frame(height: 50)
                
                
            }
            .padding(.top, 25)
            .safeAreaPadding(.horizontal, 15)
            .offset(y: minY < 0 || isSearching ? -minY : 0)
            .offset(y: -progress * 65)
            
        }
        .frame(height: 190)
        .padding(.bottom, 10)
        .padding(.bottom, isSearching ? -65 : 0)
    }
    
    // Dummy messages view
    @ViewBuilder
    func DummyMessagesView() -> some View {
        ForEach(0..<200, id: \.self) { _ in
            HStack(spacing: 12) {
                Circle()
                    .frame(width: 55, height: 55)
                VStack(alignment: .leading, spacing: 6) {
                    Rectangle()
                        .frame(width: 140, height: 8)
                    Rectangle()
                        .frame(height: 8)
                    Rectangle()
                        .frame(width: 80, height: 8)
                    
                }
            }
            .foregroundStyle(.gray.opacity(0.4))
            .padding(.horizontal, 15)
        }
    }
}

struct CustomScrollTargetBehavior: ScrollTargetBehavior {
    func updateTarget(_ target: inout ScrollTarget, context: TargetContext) {
        if target.rect.minY < 70 {
            if target.rect.minY < 35 {
                target.rect.origin = .zero
            } else {
                target.rect.origin = .init(x: 0, y: 70)
            }
        }
    }
}

#Preview {
    DiscoverView()
}
