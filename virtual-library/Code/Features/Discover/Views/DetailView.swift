//
//  DetailView.swift
//  virtual-library
//
//  Created by Riley Jenum on 23/10/24.
//

import SwiftUI

struct DetailView: View {
    
    @Binding var showDetailView: Bool
    @State private var animateContent: Bool = false
    @State private var offsetAnimation: Bool = false
    var animation: Namespace.ID
    var book: Book
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack(spacing: 15) {
                Button {
                    withAnimation(.easeOut(duration: 0.2)) {
                        offsetAnimation = false
                    }
                    
                    withAnimation(.easeOut(duration: 0.35).delay(0.1)) {
                        animateContent = false
                        showDetailView = false
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .contentShape(Rectangle())
                }
                .padding([.leading, .vertical], 15)
                .frame(maxWidth: .infinity, alignment: .leading)
                .opacity(animateContent ? 1 : 0)
                
                
                
                GeometryReader {
                    let size = $0.size
                    HStack(spacing: 20) {
                        
                        
                        AsyncImage(url: book.coverImageURL) { phase in
                            switch phase {
                            case .empty:
                                // Placeholder or loading view
                                ProgressView()
                                    .frame(width: (size.width - 30) / 2, height: size.height)
                                    .background(Color.gray.opacity(0.2))
                                    .clipShape(CustomCorners(corners: [.topRight, .bottomRight], radius: 20))
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: (size.width - 30) / 2, height: size.height)
                                    .clipShape(CustomCorners(corners: [.topRight, .bottomRight], radius: 20))
                            case .failure:
                                // Fallback view if the image fails to load
                                Image(systemName: "photo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: (size.width - 30) / 2, height: size.height)
                                    .clipShape(CustomCorners(corners: [.topRight, .bottomRight], radius: 20))
                                    .foregroundColor(.gray)
                                    .background(Color.gray.opacity(0.2))
                            }
                        }
                        .matchedGeometryEffect(id: book.id, in: animation)


                        VStack(alignment: .leading, spacing: 8) {
                            Text(book.title)
                                .font(.title)
                                .fontWeight(.semibold)
                            
                            Text("By \(book.author)")
                                .font(.callout)
                                .foregroundColor(.gray)
                            
                            RatingView(rating: book.rating ?? 4.0)

                        }
                        .padding(.trailing, 15)
                        .padding(.top, 30)
                        .offset(y: offsetAnimation ? 0 : 100)
                        .opacity(offsetAnimation ? 1 : 0)
                        
                    }
                }
                .frame(height: 220)
                .zIndex(1)
                
                Rectangle()
                    .fill(.white)
                    .ignoresSafeArea()
                    .overlay(alignment: .top, content: {
                        BookDetails()
                    })
                    .padding(.top, -180)
                    .zIndex(0)
                    .opacity(animateContent ? 1 : 0)
            }
        }
        .background {
            Rectangle()
                .fill(.white)
                .ignoresSafeArea()
                .opacity(animateContent ? 1 : 0)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.35)) {
                animateContent = true
            }
            
            withAnimation(.easeInOut(duration: 0.35).delay(0.1)) {
                offsetAnimation = true
            }
        }
    }
    
    @ViewBuilder
    func BookDetails() -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Button {
                    
                } label: {
                    Label("Reviews", systemImage: "text.alignleft")
                        .font(.callout)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                
                Button {
                    
                } label: {
                    Label("Like", systemImage: "suit.heart")
                        .font(.callout)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                
                Button {
                    
                } label: {
                    Label("Share", systemImage: "square.and.arrow.up")
                        .font(.callout)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
            }
            
            Divider()
                .padding(.top, 25)
            
            VStack(spacing: 15) {
                Text("About the book")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum")
                    .font(.callout)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 35)
            .padding(.bottom, 15)
            .padding(.top, 20)
            
            Button {
                
            } label: {
                Text("Read Now")
                    .font(.callout)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 45)
                    .padding(.vertical, 10)
                    .background {
                        Capsule()
                            .fill(.black.gradient)
                    }
                    .foregroundColor(.white)
            }
            .padding(.bottom, 15)
        }
        .padding(.top, 180)
        .offset(y: offsetAnimation ? 0 : 100)
        .opacity(offsetAnimation ? 1 : 0)
    }
}

#Preview {
    DiscoverView()
}

