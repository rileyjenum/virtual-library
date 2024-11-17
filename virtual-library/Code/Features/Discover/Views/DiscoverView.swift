//
//  DiscoverView.swift
//  virtual-library
//
//  Created by Riley Jenum on 17/10/24.
//

import SwiftUI

struct DiscoverView: View {
    
    @State private var searchText: String = ""
    @State private var activeTab: DiscoverTab = .top
    @State private var isSearching: Bool = false
    @State private var showDetailView: Bool = false
    @State private var bookResults: [Book] = []
    @State private var selectedBook: Book?
    @State private var animateCurrentBook: Bool = false
    @State private var recentSearches: [String] = []

    @FocusState private var isTyping: Bool
    @Environment(\.colorScheme) private var scheme
    @Namespace private var animation
    
    private let apiManager = GoogleBooksAPIManager()
    @State private var debounceTimer: Timer?

    
    var body: some View {
        ScrollView(.vertical) {
            Group {
                if searchText.isEmpty {
                    ForEach(recentSearches, id: \.self) { search in
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                            
                            Text(search) // Ensure the entire text is displayed
                                .font(.body)
                                .foregroundColor(.primary)
                                .lineLimit(1) // Keep one line
                                .truncationMode(.tail) // Truncate with ellipsis if too long
                            
                            Spacer()
                            
                            Button(action: {
                                RecentSearchesManager.shared.deleteSearch(search)
                                recentSearches = RecentSearchesManager.shared.loadSearches()
                            }) {
                                Image(systemName: "xmark")
                                    .foregroundColor(.gray)
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .onTapGesture {
                            withAnimation {
                                searchText = search
                            }
                        }
                    }
                } else {
                    BookScrollView(showDetailView: $showDetailView, selectedBook: $selectedBook, animateCurrentBook: $animateCurrentBook, bookResults: $bookResults, animation: animation)
                }
            }
            .safeAreaPadding(15)
            .safeAreaInset(edge: .top, spacing: 0) {
                ExpandableNavigationBar()
            }
            .animation(.snappy(duration: 0.3, extraBounce: 0), value: isTyping)
        }
        .scrollTargetBehavior(CustomScrollTargetBehavior())
        .background(.gray.opacity(0.15))
        .contentMargins(.top, 130, for: .scrollIndicators)
        .overlay {
            if let selectedBook, showDetailView {
                DetailView(showDetailView: $showDetailView, animation: animation, book: selectedBook)
                    .transition(.asymmetric(insertion: .identity, removal: .offset(y: 5)))
            }
        }
        .onChange(of: showDetailView) { oldValue, newValue in
            if !newValue {
                withAnimation(.easeInOut(duration: 0.15).delay(0.4)) {
                    animateCurrentBook = false
                }
            }
        }
        .onAppear {
            recentSearches = RecentSearchesManager.shared.loadSearches()
        }
    }
    
    private func saveRecentSearch() {
        guard !searchText.isEmpty else { return }
        RecentSearchesManager.shared.saveSearch(searchText)
        recentSearches = RecentSearchesManager.shared.loadSearches()
    }

    
    @ViewBuilder
    func ExpandableNavigationBar(_ title: String = "Discover") -> some View {
        GeometryReader {proxy in
            let minY = proxy.frame(in: .scrollView(axis: .vertical)).minY
            let scrollViewHeight = proxy.bounds(of: .scrollView(axis: .vertical))?.height ?? 0
            let scaleProgress = minY > 0 ? 1 + (max(min(minY / scrollViewHeight, 1), 0) * 0.7) : 1
            let progress = isTyping ? 1 : max(min( -minY / 70, 1), 0)
            VStack(spacing: 10) {
                // Title
                Text(title)
                    .font(.largeTitle.bold())
                    .scaleEffect(scaleProgress, anchor: .topLeading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 10)
                
                // Search bar
                HStack(spacing: 12) {
                    Image(systemName: isSearching ? "arrow.left" : "magnifyingglass")
                        .font(.title3)
                        .onTapGesture {
                            withAnimation {
                                isSearching = false
                                searchText = ""
                            }
                        }
                    
                    TextField("Search for a book", text: $searchText)
                        .focused($isTyping)
                        .padding()
                        .onChange(of: searchText) {
                            debounceSearch()
                        }
                        .onSubmit {
                            saveRecentSearch()
                        }
                    
                    if isTyping {
                        Button {
                            isTyping = false
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
                        .padding(.bottom, !isSearching ? 0 : -progress * 65)
                    
                }
                if isSearching {
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
                
                
            }
            .padding(.top, 25)
            .safeAreaPadding(.horizontal, 15)
            .offset(y: minY < 0 || isTyping ? -minY : 0)
            .offset(y: -progress * 65)
            
        }
        .frame(height: !isSearching ? 145 : 190)
        .padding(.bottom, 10)
        .padding(.bottom, isTyping ? -65 : 0)
    }
    
    private func debounceSearch() {
        debounceTimer?.invalidate()
        debounceTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
            performSearch()
        }
    }

    // Perform Search
    private func performSearch() {
        guard !searchText.isEmpty else {
            bookResults = []
            return
        }
        withAnimation {
            isSearching = true
        }
        apiManager.searchBooksByTitle(searchText) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let books):
                    withAnimation(.bouncy) {
                        bookResults = books
                    }
                case .failure(let error):
                    print("Error searching for books: \(error.localizedDescription)")
                    bookResults = []
                }
            }
        }
    }}

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


class RecentSearchesManager {
    static let shared = RecentSearchesManager()
    private let key = "RecentSearchesKey"

    private init() {}

    func saveSearch(_ search: String) {
        var searches = loadSearches()
                
        if !searches.contains(search) {
            searches.insert(search, at: 0)
            searches = Array(searches.prefix(10))
            UserDefaults.standard.set(searches, forKey: key)
        }
    }

    func loadSearches() -> [String] {
        UserDefaults.standard.array(forKey: key) as? [String] ?? []
    }

    func deleteSearch(_ search: String) {
        var searches = loadSearches()
        if let index = searches.firstIndex(of: search) {
            searches.remove(at: index)
            UserDefaults.standard.set(searches, forKey: key)
        }
    }
}
