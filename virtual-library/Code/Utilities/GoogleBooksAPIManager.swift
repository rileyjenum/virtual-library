//
//  GoogleBooksAPIManager.swift
//  virtual-library
//
//  Created by Riley Jenum on 16/11/24.
//

import Foundation

class GoogleBooksAPIManager {
    private let baseURL = "https://www.googleapis.com/books/v1/volumes"
    private let maxResults = 20
    let apiKey = "AIzaSyAJXzZqEnc0PV685KeLWv4ndyl4pax4NUo"


    func searchBooksByTitle(_ title: String, completion: @escaping (Result<[Book], Error>) -> Void) {
        guard let query = title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion(.failure(NSError(domain: "InvalidQuery", code: 400, userInfo: nil)))
            return
        }
        
        let urlString = "\(baseURL)?q=\(query)&key=\(apiKey)&maxResults=\(maxResults)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "InvalidURL", code: 400, userInfo: nil)))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: 404, userInfo: nil)))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(GoogleBooksResponse.self, from: data)
                let books = decodedResponse.items.compactMap { $0.toBook() }
                completion(.success(books))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}

// MARK: - Google Books API Response Structures
struct GoogleBooksResponse: Codable {
    let items: [GoogleBookItem]
}

struct GoogleBookItem: Codable {
    let volumeInfo: VolumeInfo
    
    func toBook() -> Book? {
        guard let title = volumeInfo.title,
              let authors = volumeInfo.authors,
              let description = volumeInfo.description,
              let publisher = volumeInfo.publisher,
              let purchaseLink = volumeInfo.infoLink,
              let totalPages = volumeInfo.pageCount else {
            return nil
        }
        let secureCoverImageURL = volumeInfo.imageLinks?.thumbnail.replacingOccurrences(of: "http://", with: "https://")

        
        return Book(
            title: title,
            author: authors.joined(separator: ", "),
            bookDescription: description,
            publisher: publisher,
            isbn: volumeInfo.industryIdentifiers?.first(where: { $0.type == "ISBN_13" })?.identifier ?? "N/A",
            coverImageURL: URL(string: secureCoverImageURL ?? ""),
            genres: volumeInfo.categories ?? [],
            dateAdded: Date(),
            readingStatus: .toRead,
            purchaseLink: URL(string: purchaseLink)!,
            totalPages: totalPages,
            pagesRead: 0,
            notes: nil,
            rating: nil,
            checkedOutBy: []
        )
    }
}

struct VolumeInfo: Codable {
    let title: String?
    let authors: [String]?
    let description: String?
    let publisher: String?
    let industryIdentifiers: [IndustryIdentifier]?
    let imageLinks: ImageLinks?
    let categories: [String]?
    let pageCount: Int?
    let infoLink: String?
}

struct IndustryIdentifier: Codable {
    let type: String
    let identifier: String
}

struct ImageLinks: Codable {
    let thumbnail: String
}
