//
//  ContentView.swift
//  MusicPlayer1.0
//
//  Created by Jose Daniel Espinoza Gomez on 20/05/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = SongViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var audioPlayerVM = AudioPlayerViewModel()
    @State private var showAddSong = false
    @State private var showProfile = false
    @State private var showPlayer = false
    
    var body: some View {
        NavigationStack {
            VStack {
                // Header con información del usuario y botones
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
                    
                    // Botón para agregar canción (+)
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
                    
                    // Botón de perfil/usuario
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
                
                // Lista de canciones
                List {
                    ForEach(viewModel.songs) { song in
                        SongRowItem(song: song, viewModel: viewModel)
                            .onTapGesture {
                                audioPlayerVM.play(song: song)
                                showPlayer = true
                            }
                    }
                    .onDelete(perform: viewModel.deleteSong)
                }
                .listStyle(.plain)
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
}

// MARK: - SongRowItem
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
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text(song.duration)
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            
            // Botón de editar
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
