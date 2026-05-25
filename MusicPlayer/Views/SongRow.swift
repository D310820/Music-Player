//
//  SongRow.swift
//  MusicPlayer1.0
//
//  Created by Jose Daniel Espinoza Gomez on 21/05/26.
import SwiftUI
import CoreData  // ✅ AGREGA ESTE IMPORT
import Combine

struct SongRow: View {
    let song: Song
    @ObservedObject var viewModel: SongViewModel
    
    var body: some View {
        HStack {
            Image(systemName: "music.note")
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 40)
            
            VStack(alignment: .leading) {
                Text(song.title)
                    .font(.headline)
                Text(song.artist)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(song.genre)
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text(formatDuration(song.duration))
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.vertical, 4)
    }
    
    private func formatDuration(_ duration: String) -> String {
        if let seconds = Double(duration) {
            let mins = Int(seconds) / 60
            let secs = Int(seconds) % 60
            return String(format: "%d:%02d", mins, secs)
        }
        return duration
    }
}

// ✅ PREVIEW CORREGIDO
#Preview {
    SongRow(
        song: Song.sampleSongs[0],
        viewModel: SongViewModel()  // ← SIN parámetros
    )
}
