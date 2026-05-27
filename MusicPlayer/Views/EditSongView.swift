//
//  EditSongView.swift
//  MusicPlayer
//  integrantes Jose Daniel Espinoza Gomez,
//  Sofia Arely Constantino Perez ,
//  Alejandre Mayreni Vazquez Velazquez,
//  Manuela Alejandra Garay Ramires.
//  Fecha 25/05/26.
import SwiftUI

struct EditSongView: View {
    @ObservedObject var viewModel: SongViewModel
    @Environment(\.dismiss) private var dismiss
    
    let song: Song
    
    @State private var title: String
    @State private var artist: String
    @State private var genre: String
    @State private var duration: String
    
    let genres = ["Pop", "Rock", "Jazz", "Clásica", "Electrónica", "Hip Hop", "Reggae", "Alternativa", "Indie", "Metal"]
    
    init(viewModel: SongViewModel, song: Song) {
        self.viewModel = viewModel
        self.song = song
        _title = State(initialValue: song.title)
        _artist = State(initialValue: song.artist)
        _genre = State(initialValue: song.genre)
        _duration = State(initialValue: song.duration)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Editar información de la canción")) {
                    TextField("Título", text: $title)
                        .textInputAutocapitalization(.words)
                    
                    TextField("Artista", text: $artist)
                        .textInputAutocapitalization(.words)
                    
                    Picker("Género", selection: $genre) {
                        ForEach(genres, id: \.self) { genre in
                            Text(genre).tag(genre)
                        }
                    }
                    
                    TextField("Duración (ej: 3:45)", text: $duration)
                        .keyboardType(.default)
                }
            }
            .navigationTitle("Editar Canción")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        updateSong()
                    }
                    .disabled(title.isEmpty || artist.isEmpty || duration.isEmpty)
                }
            }
        }
    }
    
    private func updateSong() {
        let updatedSong = Song(
            id: song.id,
            title: title,
            artist: artist,
            genre: genre,
            duration: duration,
            fileName: song.fileName,
            artworkData: nil
        )
        
        viewModel.updateSong(updatedSong)
        
        dismiss()
    }
}
