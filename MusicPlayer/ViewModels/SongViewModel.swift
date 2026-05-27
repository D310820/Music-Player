
//  SongViewModel.swift
//  MusicPlayer
//  integrantes Jose Daniel Espinoza Gomez,
//  Sofia Arely Constantino Perez ,
//  Alejandre Mayreni Vazquez Velazquez,
//  Manuela Alejandra Garay Ramires.
//  Fecha 20/05/26.
import SwiftUI
import Foundation
import Combine

class SongViewModel: ObservableObject {
    @Published var songs: [Song] = []
    
    init() {
        loadSongs()
    }
    
    func loadSongs() {
        if let savedSongs = UserDefaults.standard.data(forKey: "savedSongs") {
            if let decodedSongs = try? JSONDecoder().decode([Song].self, from: savedSongs) {
                songs = decodedSongs
                return
            }
        }
        
        songs = [
            Song(id: UUID(), title: "Bohemian Rhapsody", artist: "Queen", genre: "Rock", duration: "5:55", fileName: "bohemian"),
            Song(id: UUID(), title: "Imagine", artist: "John Lennon", genre: "Pop", duration: "3:03", fileName: "imagine"),
            Song(id: UUID(), title: "Billie Jean", artist: "Michael Jackson", genre: "Pop", duration: "4:54", fileName: "billie_jean"),
            Song(id: UUID(), title: "Shape of You", artist: "Ed Sheeran", genre: "Pop", duration: "3:53", fileName: "shape_of_you"),
            Song(id: UUID(), title: "Stairway to Heaven", artist: "Led Zeppelin", genre: "Rock", duration: "8:02", fileName: "stairway")
        ]
    }
    
    func addSong(title: String, artist: String, genre: String, duration: String, fileName: String) -> Bool {
        // Verificar si ya existe
        if songs.contains(where: { $0.title.lowercased() == title.lowercased() }) {
            return false
        }
        
        let newSong = Song(
            id: UUID(),
            title: title,
            artist: artist,
            genre: genre,
            duration: duration,
            fileName: fileName
        )
        
        songs.append(newSong)
        saveSongs()
        return true
    }
    
    func updateSong(_ updatedSong: Song) {
        if let index = songs.firstIndex(where: { $0.id == updatedSong.id }) {
            songs[index] = updatedSong
            saveSongs()
        }
    }
    
    func deleteSong(at offsets: IndexSet) {
        songs.remove(atOffsets: offsets)
        saveSongs()
    }
    
    func deleteSong(song: Song) {
        if let index = songs.firstIndex(where: { $0.id == song.id }) {
            songs.remove(at: index)
            saveSongs()
        }
    }
    
    func saveSongs() {
        if let encoded = try? JSONEncoder().encode(songs) {
            UserDefaults.standard.set(encoded, forKey: "savedSongs")
        }
    }
}
