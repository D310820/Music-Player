//
//  Song.swift
//  MusicPlayer1.0
//
//  Created by Jose Daniel Espinoza Gomez on 20/05/26.
//

import Foundation
import SwiftUI

struct Song: Identifiable, Codable {
    let id: UUID
    let title: String
    let artist: String
    let genre: String
    let duration: String
    let fileName: String
    var artworkData: Data? // Para la imagen del álbum
    
    init(id: UUID = UUID(), title: String, artist: String, genre: String, duration: String, fileName: String, artworkData: Data? = nil) {
        self.id = id
        self.title = title
        self.artist = artist
        self.genre = genre
        self.duration = duration
        self.fileName = fileName
        self.artworkData = artworkData
    }
    
    // Propiedad computada para obtener la URL del archivo
    var fileURL: URL? {
        // Buscar en el bundle principal
        if let url = Bundle.main.url(forResource: fileName, withExtension: "mp3") {
            return url
        }
        // Buscar en documentos
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsPath.appendingPathComponent("\(fileName).mp3")
        return FileManager.default.fileExists(atPath: fileURL.path) ? fileURL : nil
    }
    
    // Canciones de ejemplo (estático)
    static var sampleSongs: [Song] {
        return [
            Song(title: "Bohemian Rhapsody", artist: "Queen", genre: "Rock", duration: "5:55", fileName: "bohemian"),
            Song(title: "Imagine", artist: "John Lennon", genre: "Pop", duration: "3:03", fileName: "imagine"),
            Song(title: "Billie Jean", artist: "Michael Jackson", genre: "Pop", duration: "4:54", fileName: "billie_jean")
        ]
    }
}

// Para hacer que Song sea Equatable
extension Song: Equatable {
    static func == (lhs: Song, rhs: Song) -> Bool {
        lhs.id == rhs.id
    }
}
