////
//  AddSongView.swift
//  MusicPlayer1.0
//
//  Created by Jose Daniel Espinoza Gomez on 21/05/26.
//
//  AddSongView.swift
//  MusicPlayer1.0
//
//  Created by Jose Daniel Espinoza Gomez on 21/05/26.
//

import SwiftUI
import UniformTypeIdentifiers
import AVFoundation

struct AddSongView: View {
    @ObservedObject var viewModel: SongViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var artist = ""
    @State private var genre = "Pop"
    @State private var showingFilePicker = false
    @State private var selectedFileURL: URL?
    @State private var fileName = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var isImporting = false
    
    let genres = ["Pop", "Rock", "Jazz", "Clásica", "Electrónica", "Hip Hop", "Reggae", "Alternativa", "Indie", "Metal"]
    
    var isFormValid: Bool {
        !title.isEmpty && !artist.isEmpty && !fileName.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Información de la canción")) {
                    TextField("Título", text: $title)
                        .textInputAutocapitalization(.words)
                    
                    TextField("Artista", text: $artist)
                        .textInputAutocapitalization(.words)
                    
                    Picker("Género", selection: $genre) {
                        ForEach(genres, id: \.self) { genre in
                            Text(genre).tag(genre)
                        }
                    }
                }
                
                Section(header: Text("Archivo de música")) {
                    HStack {
                        Image(systemName: "music.note")
                            .foregroundColor(.blue)
                        
                        VStack(alignment: .leading) {
                            Text(selectedFileURL?.lastPathComponent ?? "Ningún archivo seleccionado")
                                .font(.caption)
                                .foregroundColor(selectedFileURL == nil ? .secondary : .primary)
                            
                            if !fileName.isEmpty {
                                Text("Nombre interno: \(fileName).mp3")
                                    .font(.caption2)
                                    .foregroundColor(.green)
                            }
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            isImporting = true
                        }) {
                            Label("Seleccionar", systemImage: "folder")
                                .font(.caption)
                        }
                        .buttonStyle(.bordered)
                    }
                    .padding(.vertical, 8)
                    
                    if selectedFileURL != nil {
                        Button(action: {
                            saveSongToAppDirectory()
                        }) {
                            Label("Guardar archivo en la app", systemImage: "square.and.arrow.down")
                                .font(.caption)
                                .foregroundColor(.blue)
                        }
                        .buttonStyle(.borderless)
                    }
                    
                    Text("Selecciona un archivo MP3 de tu dispositivo")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Agregar Canción")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        saveSong()
                    }
                    .disabled(!isFormValid || selectedFileURL == nil)
                }
            }
            .alert("Mensaje", isPresented: $showingAlert) {
                Button("OK") {
                    if alertMessage.contains("éxito") {
                        dismiss()
                    }
                }
            } message: {
                Text(alertMessage)
            }
            .fileImporter(
                isPresented: $isImporting,
                allowedContentTypes: [.audio],
                allowsMultipleSelection: false
            ) { result in
                switch result {
                case .success(let urls):
                    guard let url = urls.first else { return }
                    selectedFileURL = url
                    fileName = url.deletingPathExtension().lastPathComponent
                        .replacingOccurrences(of: " ", with: "_")
                        .lowercased()
                    alertMessage = "Archivo seleccionado: \(url.lastPathComponent)"
                    showingAlert = true
                case .failure(let error):
                    alertMessage = "Error al seleccionar archivo: \(error.localizedDescription)"
                    showingAlert = true
                }
            }
        }
    }
    
    private func saveSongToAppDirectory() {
        guard let sourceURL = selectedFileURL else { return }
        
        // Obtener el directorio de documentos de la app
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let destinationURL = documentsPath.appendingPathComponent("\(fileName).mp3")
        
        // Copiar el archivo al directorio de la app
        do {
            if FileManager.default.fileExists(atPath: destinationURL.path) {
                try FileManager.default.removeItem(at: destinationURL)
            }
            try FileManager.default.copyItem(at: sourceURL, to: destinationURL)
            alertMessage = "Archivo guardado exitosamente en la app"
            showingAlert = true
        } catch {
            alertMessage = "Error al guardar archivo: \(error.localizedDescription)"
            showingAlert = true
        }
    }
    
    private func saveSong() {
        // Guardar archivo si no se ha guardado
        if let sourceURL = selectedFileURL {
            let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let destinationURL = documentsPath.appendingPathComponent("\(fileName).mp3")
            
            if !FileManager.default.fileExists(atPath: destinationURL.path) {
                do {
                    try FileManager.default.copyItem(at: sourceURL, to: destinationURL)
                } catch {
                    alertMessage = "Error al guardar archivo: \(error.localizedDescription)"
                    showingAlert = true
                    return
                }
            }
        }
        
        // Crear la canción con duración automática o por defecto
        let duration = getAudioDuration() ?? "3:00"
        
        let success = viewModel.addSong(
            title: title,
            artist: artist,
            genre: genre,
            duration: duration,
            fileName: fileName
        )
        
        if success {
            alertMessage = "Canción agregada con éxito"
            showingAlert = true
            resetForm()
        } else {
            alertMessage = "Error: Ya existe una canción con ese título"
            showingAlert = true
        }
    }
    
    private func getAudioDuration() -> String? {
        guard let sourceURL = selectedFileURL else { return nil }
        
        do {
            let audioPlayer = try AVAudioPlayer(contentsOf: sourceURL)
            let duration = audioPlayer.duration
            let minutes = Int(duration) / 60
            let seconds = Int(duration) % 60
            return String(format: "%d:%02d", minutes, seconds)
        } catch {
            print("Error al obtener duración: \(error)")
            return nil
        }
    }
    
    private func resetForm() {
        title = ""
        artist = ""
        genre = "Pop"
        fileName = ""
        selectedFileURL = nil
    }
}
