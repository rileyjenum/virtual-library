//
//  Book.swift
//  virtual-library
//
//  Created by Riley Jenum on 17/10/24.
//

import Foundation

struct Book: Identifiable, Hashable {
    var id: String = UUID().uuidString
    var title: String
    var imageName: String
    var author: String
    var rating: Int
    var bookViews: Int
}

var sampleBooks: [Book] = [
    .init(title: "Walking with Miss Millie", imageName: "Book 1", author: "Rachel Lippincott", rating: 4, bookViews: 1023),
    .init(title: "Five Feet Apart", imageName: "Book 2", author: "William B. Irvine", rating: 5, bookViews: 2049),
    .init(title: "The Alchemist", imageName: "Book 3", author: "Anne", rating: 4, bookViews: 920),
    .init(title: "The Book of Happiness", imageName: "Book 4", author: "William Lippincott", rating: 3, bookViews: 560),
    .init(title: "Living Alone", imageName: "Book 5", author: "Jenna Lippincott", rating: 5, bookViews: 240)
]
