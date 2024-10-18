//
//  Home.swift
//  virtual-library
//
//  Created by Riley Jenum on 17/10/24.
//

import SwiftUI

struct Home: View {
    
    @State private var activeTag: String = "Biography"
    @Namespace private var animation

    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Text("Browse")
                    .font(.largeTitle.bold())
                Text("Recommended")
                .fontWeight(.semibold)
                .padding(.leading, 15)
                .foregroundColor(.gray)
                .offset(y: 2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 15)
            
            TagsView()
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 15) {
                    ForEach(sampleBooks) {
                        BookCardView($0)
                    }
                }
            }
            .coordinateSpace(name: "SCROLLVIEW")
        }
    }
    
    @ViewBuilder
    func BookCardView(_ book: Book) -> some View {
        GeometryReader {
            let size = $0.size
            let rect = $0.frame(in: .named("SCROLLVIEW"))
            
            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 6) {
                    
                }
                .frame(width: size.width / 2)
                
                ZStack {
                    Image(book.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width / 2, height: size.height)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(width: size.width)
        }
        .frame(height: 220)
    }
    
    
    @ViewBuilder
    func TagsView() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(tags, id: \.self) { tag in
                    Text(tag)
                        .font(.caption)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 5)
                        .background {
                            if activeTag == tag {
                                Capsule()
                                    .fill(Color.blue)
                                    .matchedGeometryEffect(id: "ACTIVETAB", in: animation)

                            } else {
                                Capsule()
                                    .fill(Color.gray.opacity(0.2))
                            }
                        }
                        .foregroundColor(activeTag == tag ? .white : .gray)
                        .onTapGesture {
                            withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.7)) {
                                activeTag = tag
                            }
                        }

                }
            }
            .padding(.horizontal, 15)
        }
    }
}

var tags: [String] = [
    "History", "Classical", "Biography", "Cartoon", "Adventure", "Fairy Tales", "Fantasy"
]

#Preview {
    Home()
}
