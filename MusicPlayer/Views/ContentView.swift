//
//  ContentView.swift
//  MusicPlayer
//  integrantes Jose Daniel Espinoza Gomez,
//  Sofia Arely Constantino Perez ,
//  Alejandre Mayreni Vazquez Velazquez,
//  Manuela Alejandra Garay Ramires.
//  Fecha 20/05/26.
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = SongViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var audioPlayerVM = AudioPlayerViewModel()
    @State private var showAddSong = false
    @State private var showProfile = false
    @State private var showPlayer = false
    
    // MARK: - Propiedades para búsqueda y filtrado
    @State private var searchText = ""
    @State private var selectedGenre = "Todos"
    
    // Lista de géneros disponibles (basada en las canciones)
    var availableGenres: [String] {
        let genres = Set(viewModel.songs.map { $0.genre })
        return ["Todos"] + genres.sorted()
    }
    
    // Canciones filtradas por búsqueda y género
    var filteredSongs: [Song] {
        var filtered = viewModel.songs
        
        // Filtro por género
        if selectedGenre != "Todos" {
            filtered = filtered.filter { $0.genre == selectedGenre }
        }
        
        // Filtro por búsqueda
        if !searchText.isEmpty {
            filtered = filtered.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.artist.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return filtered
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Hola, \(authViewModel.currentSession?.username ?? "Usuario")")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("Tu biblioteca musical")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Button(action: { showAddSong = true }) {
                        Circle()
                            .fill(Color.green.opacity(0.2))
                            .frame(width: 45, height: 45)
                            .overlay(
                                Image(systemName: "plus")
                                    .font(.title2)
                                    .foregroundColor(.green)
                            )
                    }
                    
                    Button(action: { showProfile = true }) {
                        Circle()
                            .fill(Color.blue.opacity(0.2))
                            .frame(width: 45, height: 45)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .foregroundColor(.blue)
                            )
                    }
                }
                .padding()
                
                SearchBar(text: $searchText, placeholder: "Buscar canción o artista")
                    .padding(.horizontal)
                    .padding(.bottom, 8)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(availableGenres, id: \.self) { genre in
                            GenreChip(genre: genre, isSelected: selectedGenre == genre) {
                                selectedGenre = genre
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 8)
                
                if filteredSongs.isEmpty {
                    VStack(spacing: 20) {
                        Spacer()
                        Image(systemName: "music.note.list")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("No se encontraron canciones")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Text("Prueba con otro filtro o agrega nuevas canciones")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(filteredSongs) { song in
                            SongRowItem(song: song, viewModel: viewModel)
                                .onTapGesture {
                                    audioPlayerVM.play(song: song)
                                    showPlayer = true
                                }
                        }
                        .onDelete(perform: deleteSong)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationDestination(isPresented: $showAddSong) {
                AddSongView(viewModel: viewModel)
            }
            .navigationDestination(isPresented: $showProfile) {
                ProfileView()
                    .environmentObject(authViewModel)
            }
            .navigationDestination(isPresented: $showPlayer) {
                PlayerView(audioPlayerVM: audioPlayerVM)
            }
        }
    }
    
    private func deleteSong(at offsets: IndexSet) {
        // Eliminar las canciones originales (no las filtradas)
        let songsToDelete = offsets.map { filteredSongs[$0] }
        for song in songsToDelete {
            if let index = viewModel.songs.firstIndex(where: { $0.id == song.id }) {
                viewModel.songs.remove(at: index)
            }
        }
        viewModel.saveSongs()
    }
}

struct SearchBar: View {
    @Binding var text: String
    var placeholder: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField(placeholder, text: $text)
                .textFieldStyle(PlainTextFieldStyle())
                .autocapitalization(.none)
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(10)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

struct GenreChip: View {
    let genre: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(genre)
                .font(.subheadline)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.blue : Color.gray.opacity(0.2))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(20)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct SongRowItem: View {
    let song: Song
    @ObservedObject var viewModel: SongViewModel
    @State private var showEditSheet = false
    
    var body: some View {
        HStack {
            Image(systemName: "music.note")
                .foregroundColor(.blue)
                .font(.title3)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(song.title)
                    .font(.headline)
                    .fontWeight(.medium)
                
                Text(song.artist)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(song.genre)
                    .font(.caption2)
                    .foregroundColor(.blue)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(10)
            }
            
            Spacer()
            
            Text(song.duration)
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            
            Button(action: {
                showEditSheet = true
            }) {
                Image(systemName: "pencil.circle")
                    .foregroundColor(.blue)
                    .font(.title3)
            }
            .buttonStyle(BorderlessButtonStyle())
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
        .sheet(isPresented: $showEditSheet) {
            EditSongView(viewModel: viewModel, song: song)
        }
    }
}
