//
//  ReadingSession.swift
//  virtual-library
//
//  Created by Riley Jenum on 12/11/24.
//

import Foundation
import SwiftData

@Model
final class ReadingSession: Identifiable {
    @Attribute(.unique) var id: UUID = UUID()
    var startTime: Date
    var duration: TimeInterval
    var pagesCompleted: Int
    var mood: ReadingMood
    var book: Book
    
    enum ReadingMood: String, Codable {
        case happy, sad, inspired, thoughtful
    }
    
    init(startTime: Date, duration: TimeInterval, pagesCompleted: Int, mood: ReadingMood, book: Book) {
        self.startTime = startTime
        self.duration = duration
        self.pagesCompleted = pagesCompleted
        self.mood = mood
        self.book = book
    }
}
