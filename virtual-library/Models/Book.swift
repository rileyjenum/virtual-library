//
//  Book.swift
//  virtual-library
//
//  Created by Riley Jenum on 12/11/24.
//

import Foundation
import SwiftData

@Model
final class Book: Identifiable {
    @Attribute(.unique) var id: UUID = UUID()
    var title: String
    var author: String
    var bookDescription: String
    var publisher: String
    var isbn: String
    var coverImageURL: URL?
    var genres: [String]
    var dateAdded: Date
    var readingStatus: ReadingStatus
    var purchaseLink: URL
    var totalPages: Int
    var pagesRead: Int
    var notes: String?
    var rating: Double?
    var timeSpentReading: TimeInterval = 0
    var checkedOutBy: [String] = []
    
    enum ReadingStatus: String, Codable {
        case toRead, reading, finished
    }
    
    init(
        title: String,
        author: String,
        bookDescription: String,
        publisher: String,
        isbn: String,
        coverImageURL: URL? = nil,
        genres: [String] = [],
        dateAdded: Date = Date(),
        readingStatus: ReadingStatus,
        purchaseLink: URL,
        totalPages: Int,
        pagesRead: Int = 0,
        notes: String? = nil,
        rating: Double? = nil,
        checkedOutBy: [String] = []
    ) {
        self.title = title
        self.author = author
        self.bookDescription = bookDescription
        self.publisher = publisher
        self.isbn = isbn
        self.coverImageURL = coverImageURL
        self.genres = genres
        self.dateAdded = dateAdded
        self.readingStatus = readingStatus
        self.purchaseLink = purchaseLink
        self.totalPages = totalPages
        self.pagesRead = pagesRead
        self.notes = notes
        self.rating = rating
        self.checkedOutBy = checkedOutBy
    }
}

import Foundation

let sampleBooks: [Book] = [
    Book(
        title: "To Kill a Mockingbird",
        author: "Harper Lee",
        bookDescription: "A novel about the serious issues of rape and racial inequality.",
        publisher: "J.B. Lippincott & Co.",
        isbn: "978-0061120084",
        coverImageURL: URL(string: "https://books.google.com/books/content?id=PGR2AwAAQBAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api"),
        genres: ["Fiction", "Classic", "Historical"],
        dateAdded: Date(),
        readingStatus: .finished,
        purchaseLink: URL(string: "https://example.com/mockinbird-buy")!,
        totalPages: 324,
        pagesRead: 324,
        notes: "A deeply moving book.",
        rating: 4.8,
        checkedOutBy: ["user123", "user456"]
    ),
    Book(
        title: "1984",
        author: "George Orwell",
        bookDescription: "A dystopian social science fiction novel and cautionary tale.",
        publisher: "Secker & Warburg",
        isbn: "978-0451524935",
        coverImageURL: URL(string: "https://books.google.com/books/content?id=kotPYEqx7kMC&printsec=frontcover&img=1&zoom=1&source=gbs_api"),
        genres: ["Fiction", "Dystopian", "Classic"],
        dateAdded: Date(),
        readingStatus: .toRead,
        purchaseLink: URL(string: "https://example.com/1984-buy")!,
        totalPages: 328,
        pagesRead: 0,
        notes: "Looking forward to reading this classic!",
        rating: nil,
        checkedOutBy: []
    ),
    Book(
        title: "The Great Gatsby",
        author: "F. Scott Fitzgerald",
        bookDescription: "A novel that explores themes of wealth, love, and the American Dream.",
        publisher: "Charles Scribner's Sons",
        isbn: "978-0743273565",
        coverImageURL: URL(string: "https://books.google.com/books/content?id=0NEbHGREK7cC&printsec=frontcover&img=1&zoom=1&source=gbs_api"),
        genres: ["Fiction", "Classic", "American Literature"],
        dateAdded: Date(),
        readingStatus: .reading,
        purchaseLink: URL(string: "https://example.com/gatsby-buy")!,
        totalPages: 180,
        pagesRead: 120,
        notes: "Intriguing look at wealth and society in the 1920s.",
        rating: 4.5,
        checkedOutBy: ["user789"]
    ),
    Book(
        title: "Pride and Prejudice",
        author: "Jane Austen",
        bookDescription: "A romantic novel that also offers a critique of British society in the early 19th century.",
        publisher: "T. Egerton, Whitehall",
        isbn: "978-1503290563",
        coverImageURL: URL(string: "https://books.google.com/books/content?id=8alSQgAACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api"),
        genres: ["Fiction", "Romance", "Classic"],
        dateAdded: Date(),
        readingStatus: .finished,
        purchaseLink: URL(string: "https://example.com/pride-prejudice-buy")!,
        totalPages: 279,
        pagesRead: 279,
        notes: "A timeless romance!",
        rating: 4.9,
        checkedOutBy: ["user123", "user789", "user456"]
    ),
    Book(
        title: "The Catcher in the Rye",
        author: "J.D. Salinger",
        bookDescription: "A story about teenage rebellion and angst.",
        publisher: "Little, Brown and Company",
        isbn: "978-0316769488",
        coverImageURL: URL(string: "https://books.google.com/books/content?id=0NEbHGREK7cC&printsec=frontcover&img=1&zoom=1&source=gbs_api"),
        genres: ["Fiction", "Classic", "Young Adult"],
        dateAdded: Date(),
        readingStatus: .toRead,
        purchaseLink: URL(string: "https://example.com/catcher-rye-buy")!,
        totalPages: 214,
        pagesRead: 0,
        notes: nil,
        rating: nil,
        checkedOutBy: []
    )
]

