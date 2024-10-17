//
//  ContentView.swift
//  virtual-library
//
//  Created by Riley Jenum on 17/10/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            Home()
                .toolbar(.hidden, for: .navigationBar)
        }
    }
}

#Preview {
    ContentView()
}
