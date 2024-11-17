//
//  Home.swift
//  virtual-library
//
//  Created by Riley Jenum on 17/10/24.
//

import SwiftUI

struct BookScrollView: View {
    
    @State private var activeTag: String = "Biography"
    @State private var carouselMode: Bool = true
    @Binding var showDetailView: Bool
    @Binding var selectedBook: Book?
    @Binding var animateCurrentBook: Bool
    @Binding var bookResults: [Book]

    var animation: Namespace.ID

    var body: some View {
        VStack(spacing: 35) {
            ForEach(bookResults) { book in
                BookCardView(book)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            animateCurrentBook = true
                            selectedBook = book
                            
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                            withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                                showDetailView = true
                            }
                        }
                    }
                    .transition(AnyTransition.scale)
            }
        }
        .padding(.horizontal, 15)
        .padding(.bottom, 60)
    }
    
    @ViewBuilder
    func BookCardView(_ book: Book) -> some View {
        GeometryReader {
            let size = $0.size
            HStack(spacing: -25) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(book.title)
                        .font(.title3)
                        .fontWeight(.semibold)
                    Text("By \(book.author)")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    RatingView(rating: book.rating ?? 4.0)
                        .padding(.top, 10)
                    
                    Spacer(minLength: 10)
                    
                    HStack(spacing: 4) {
                        Text("12")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                        
                        Text("Views")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Spacer(minLength: 0)
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Image(systemName: "chevron.right")
                    }
                    
                }
                .padding(20)
                .frame(width: size.width / 2, height: size.height * 0.8)
                .background {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(.white)
                        .shadow(color: .black.opacity(0.08), radius: 8, x: 5, y: 5)
                        .shadow(color: .black.opacity(0.08), radius: 8, x: -5, y: -5)

                }
                .zIndex(1)
                .offset(x: animateCurrentBook && selectedBook?.id == book.id ? -20 : 0)
                ZStack {
                    if !(showDetailView && selectedBook?.id == book.id) {
                        AsyncImage(url: book.coverImageURL) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(width: size.width / 2, height: size.height)
                                    .background(Color.gray.opacity(0.2))
                                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: size.width / 2, height: size.height)
                                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                    .shadow(color: .black.opacity(0.1), radius: 5, x: 5, y: 5)
                                    .shadow(color: .black.opacity(0.1), radius: 5, x: -5, y: -5)
                            case .failure:
                                // Fallback view if the image fails to load
                                Image(systemName: "photo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: size.width / 2, height: size.height)
                                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                    .foregroundColor(.gray)
                                    .background(Color.gray.opacity(0.2))
                                    .shadow(color: .black.opacity(0.1), radius: 5, x: 5, y: 5)
                                    .shadow(color: .black.opacity(0.1), radius: 5, x: -5, y: -5)
                            @unknown default:
                                Image(systemName: "photo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: size.width / 2, height: size.height)
                                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                    .foregroundColor(.gray)
                                    .background(Color.gray.opacity(0.2))
                                    .shadow(color: .black.opacity(0.1), radius: 5, x: 5, y: 5)
                                    .shadow(color: .black.opacity(0.1), radius: 5, x: -5, y: -5)
                            }
                        }
                        .matchedGeometryEffect(id: book.id, in: animation)


                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(width: size.width)
        }
        .frame(height: 220)
    }
}
// Preview
struct BookScrollView_Previews: PreviewProvider {
    @Namespace static var animation
    @State static var showDetailView = false
    @State static var selectedBook: Book? = nil
    @State static var animateCurrentBook = false
    @State static var bookResults: [Book] = []

    
    static var previews: some View {
        BookScrollView(
            showDetailView: $showDetailView,
            selectedBook: $selectedBook,
            animateCurrentBook: $animateCurrentBook,
            bookResults: $bookResults,
            animation: animation
        )
    }
}

